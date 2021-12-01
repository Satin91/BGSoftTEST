//
//  ViewController.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit
import CoreMotion



class MainViewController: UIViewController {
    
    
    var collectionView: PhotoCollectionView!
    var currentIndexPath: IndexPath?
    let photoStorage = PhotoModelController()
    var photos = [PhotoModel]()
    
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
        setupCollectionView()
        constraints()
        photoStorage.getModelArray()
        photos = photoStorage.createEndlessСarousel()
        scrollToFirstItem(animated: false)
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false, block: { timer in
            self.scrollToFirstItem(animated: true)
        })
    }
    
    func scrollToFirstItem(animated: Bool) {
        let firstItemIndex = IndexPath(item: photos.count / 2 , section: 0)
        self.collectionView.scrollToItem(at: firstItemIndex , at: .centeredVertically, animated: animated)
        guard currentIndexPath == nil else { return }
        self.currentIndexPath = firstItemIndex
    }
  
    
    // MARK: Загрузка фотографий по соседству от видимой ячейки
    
  
    
    func setupCollectionView() {
        collectionView = PhotoCollectionView(frame: self.view.bounds)
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .systemGray4
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate   = self
        collectionView.dataSource = self
    }
    //работает на iPad
        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            print(#function)
    
            DispatchQueue.main.async { [self] in
                collectionView.layout.isLandscape = UIDevice.current.orientation.isLandscape
                collectionView.scrollToItem(at: self.currentIndexPath!, at: .centeredHorizontally, animated: false)
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

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
  
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        userIsSleeping = false
        //MARK: Parallax эффект
        for cell in collectionView.visibleCells as! [PhotoCollectionViewCell] {
            cell.parallax(offsetPoint: self.collectionView.contentOffset)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let indexPath = collectionView.indexPathsForVisibleItems.first else { return }
        self.currentIndexPath = indexPath
        collectionView.reloadData()
        userIsSleeping = true
        photoStorage.loadAdjacentPhotos(currentIndex: indexPath, from: self.photos)
        print(indexPath.row)
        if indexPath.row == photos.count - 1  || indexPath.row == 0 {
            scrollToFirstItem(animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    // MARK: Загрузка происходит в этом методе чтобы исключить "Мерцание" фотографий
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        let object = photos[indexPath.row]
        let imageVV = UIImageView()
        
        imageVV.loadPhoto(imageUrl: object.imageURL) { isLoaded in
            if isLoaded {
                collectionView.reloadData()
            }
        }
        cell.buttonAction = { [weak self] in
            guard let self = self else { return }
            self.showAlert(name: object.name)
        }
        cell.photo.image = imageVV.image
        cell.configure(object: object)
        cell.linkDelegate = self
        return cell
    }
}



