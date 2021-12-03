//
//  ViewController.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit
import CoreMotion



class MainViewController: UIViewController {
    
 
    
    var compositionalLayoutIsUsing: Bool = false
    var collectionView: PhotoCollectionView!
    var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    let photoStorage = PhotoModelController()
    let scaleLayout = HorizontalPagingLayout()
    var composLayout: CompositionalLayout?
    let factor = 10
    // Блюр используется во время переключения layout'а коллекции
    var blur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent) )
    
   
    
    var photos = [PhotoModel]()
    var photosCount: Int?
    
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
        
        // Получение сортированного массива фотографий
        photoStorage.getModelArray()
        // Присвоение массива классовой переменной
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
        self.composLayout = CompositionalLayout(collectionView: collectionView)
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .systemGray4
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate   = self
        collectionView.dataSource = self
        composLayout?.sendIndexDelegate = self
    }
   // работает на iPad
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        print(#function)
//        self.scaleLayout.isLandscape = UIDevice.current.orientation.isLandscape
//        DispatchQueue.main.async { [self] in
//            collectionView.scrollToItem(at: self.currentIndexPath, at: .centeredHorizontally, animated: false)
//        }
//    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        print(#function)
        self.scaleLayout.isLandscape  = UIDevice.current.orientation.isLandscape
        self.composLayout?.isLandscape = UIDevice.current.orientation.isLandscape
        DispatchQueue.main.async { [self] in
            print(currentIndexPath)
            collectionView.scrollToItem(at: self.currentIndexPath, at: .centeredVertically, animated: false)
        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            // Происходит когда в айпаде открывают мультитаскинг
            collectionView.layout.isCompact = true
        } else {
            // обычное состояние
            collectionView.layout.isCompact = false
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        userIsSleeping = true
        
        if collectionView.indexPathsForVisibleItems.first!.row == 0 {
            scrollToFirstItem(animated: false)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        userIsSleeping = false
        print(currentIndexPath)
        for cell in collectionView.visibleCells as! [PhotoCollectionViewCell] {
            cell.parallax(offsetPoint: self.collectionView.contentOffset)
        }
        let centerPoint = CGPoint(x: self.collectionView.center.x + self.collectionView.contentOffset.x,
                                        y: self.collectionView.center.y + self.collectionView.contentOffset.y)
        
        guard let index = collectionView.indexPathForItem(at: centerPoint) else { return }
        
        // Блокировка назначения действующего индекса в момент смены ориентации
        guard index != IndexPath(item: 0, section: 0) && !(index.row < currentIndexPath.row - 2) && !(index.row > currentIndexPath.row + 2)  else { return }
        currentIndexPath = index
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count * factor
    }
    
    
    // MARK: Загрузка происходит в этом методе чтобы исключить "Мерцание" фотографий
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? PhotoCollectionViewCell else { return }
        let object = photos[indexPath.row % photos.count]
        
        let imageVV = UIImageView()
        cell.imageUrl = object.imageURL
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
            self.showAlert(row: actualIndex)
        }

        cell.configure(object: object)
        cell.linkDelegate = self
        return cell
    }

}



extension MainViewController: CompositionalFirstIndex {
    func sendValueOf(indexPath: IndexPath) {
        
        // Блокировка назначения действующего индекса в момент смены ориентации
        self.currentIndexPath = indexPath
    }
    
    
}
