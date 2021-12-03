//
//  ViewController.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit
import CoreMotion


protocol LayoutIsCompositional {
    var compositionalLayoutIsUsing: Bool { get set }
}

class MainViewController: UIViewController{
    
    // Layouts
    let scaleLayout = HorizontalPagingLayout() // Layout с анимацией увеличения ячейки
    var composLayout: CompositionalLayout?     // Layout для отображения четырех ячеек
    
    // Используется ли в данный момент compositional layout
    var compositionalLayoutIsUsing: Bool = false {
        didSet {
            self.parallaxIsUsed = !compositionalLayoutIsUsing
        }
    }
    
    // Так как UIImageView в ячейке не привязан констрейнтами, нужно отслеживать состояние когда его фрейму нужно привязаться к ячейке в момент обновления лейаута, или быть изменяемым для параллакса
    private var parallaxIsUsed: Bool = true
    
    // Свойство содержит текущий индекс и нужен для скрола к нему в момент смены ориентации или лейаута
    var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    // Экземпляр класса с методами, которые работают с моделью
    private let photoStorage = PhotoModelController()
    
    // Множитель который дает произведение количества ячеек для "бесконечной" прокрутки
    let factor = 10
    
    // Блюр используется во время переключения layout'а коллекции
    var blur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent) )
    
    var collectionView: PhotoCollectionView!
    var photos = [PhotoModel]()
    
    // Таймер запускается в момент бездействия пользователя
    private var timer = Timer()
    var userIsSleeping = false {
        willSet {
            if newValue == false {
                timer.invalidate()
            } else {
                timer.invalidate()
                startTimer()
            }
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        photoStorage.getModelArray()
        photos = photoStorage.photos
        setupCollectionView()
        constraints()
        scrollToFirstItem(animated: false)
        addBlurToView()
        addPinchGesture()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false, block: { timer in
            self.scrollToFirstItem(animated: true)
        })
    }
    
    func addBlurToView() {
        self.blur.frame = self.view.bounds
        self.view.addSubview(blur)
        self.blur.alpha = 0
    }
    
    func scrollToFirstItem(animated: Bool) {
        let firstItemIndex = IndexPath(item: (photos.count * factor) / 2 , section: 0)
        self.collectionView.scrollToItem(at: firstItemIndex , at: .centeredVertically, animated: animated)
        self.currentIndexPath = firstItemIndex
        
    }
    
    func setupCollectionView() {
        
        collectionView = PhotoCollectionView(frame: self.view.bounds, collectionViewLayout: scaleLayout)
        self.composLayout = CompositionalLayout(collectionView: self.collectionView)
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .systemGray4
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate   = self
        collectionView.dataSource = self
        composLayout?.sendIndexDelegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print(#function)
       
        self.scaleLayout.isLandscape  = UIDevice.current.orientation.isLandscape
        self.composLayout?.isLandscape = UIDevice.current.orientation.isLandscape
        self.parallaxIsUsed = false
        
        DispatchQueue.main.async { [self] in
            collectionView.scrollToItem(at: self.currentIndexPath, at: .centeredVertically, animated: false)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            // Происходит когда в айпаде открывают мультитаскинг
            self.scaleLayout.isCompact = true
        } else {
            // обычное состояние
            self.scaleLayout.isCompact = false
        }
    }
}

// MARK: Delegate/Datasource

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        userIsSleeping = true
        if collectionView.indexPathsForVisibleItems.first?.row == 0 {
            scrollToFirstItem(animated: false)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        userIsSleeping = false
        // Параллакс эффект
        for cell in collectionView.visibleCells as! [PhotoCollectionViewCell] {
            cell.parallax(offsetPoint: self.collectionView.contentOffset)
        }
        let centerPoint = CGPoint(x: self.collectionView.center.x + self.collectionView.contentOffset.x,
                                        y: self.collectionView.center.y + self.collectionView.contentOffset.y)
        
        guard let index = collectionView.indexPathForItem(at: centerPoint) else { return }
        guard let cell = collectionView.cellForItem(at: index) as? PhotoCollectionViewCell else { return }
        cell.useParallax = self.parallaxIsUsed
        // Блокировка назначения текущего индекса в момент смены ориентации
        guard index != IndexPath(item: 0, section: 0) && !(index.row < currentIndexPath.row - 2) && !(index.row > currentIndexPath.row + 2)  else { return }
        currentIndexPath = index
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count * factor
    }
    
    // Загрузка фотографии происходит в этом методе чтобы исключить "Мерцание" фотографий
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? PhotoCollectionViewCell else { return }
        let actualIndex = indexPath.row % photos.count
        let object = photos[indexPath.row % photos.count]
        let imageVV = UIImageView()
        self.photoStorage.loadAdjacentPhotos(currentIndex: actualIndex , from: self.photos)
        imageVV.loadPhoto(imageUrl: object.imageURL) { isLoaded in
            if isLoaded {
                if cell.imageUrl == object.imageURL {
                    cell.photo.image = imageVV.image
                }
            }
        }
        cell.photo.image = imageVV.image
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        let actualIndex = indexPath.row % photos.count
        let object = photos[actualIndex]
        
        cell.buttonAction = { [weak self] in
            guard let self = self else { return }
            self.currentIndexPath = indexPath
            self.showDeletionAlert(row: actualIndex)
        }
        cell.imageUrl = object.imageURL
        cell.configure(object: object, parallax: self.parallaxIsUsed)
        cell.linkDelegate = self
        return cell
    }
    
}

//MARK: Получение действующего индекса из compositional layout

extension MainViewController: CompositionalFirstIndex {
    func sendValueOf(firstIndexPath: IndexPath) {
        self.currentIndexPath = firstIndexPath
    }
}
