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
    let photoStorage = PhotoStorage()
    private var photos  = [PhotoModel]()
    var timer = Timer()
   
    
    
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
         
        //timer.fire()
        photos = photoStorage.getPhotos()
        scrollToFirstItem(animated: false)
        
    }
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false, block: { timer in
            self.scrollToFirstItem(animated: true)
        })
    }
    func scrollToFirstItem(animated: Bool) {
        self.collectionView.scrollToItem(at: IndexPath(item: photos.count / 2 , section: 0), at: .centeredVertically, animated: animated)
    }
    
    func setupCollectionView() {
        collectionView = PhotoCollectionView(frame: self.view.bounds)
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate   = self
        collectionView.dataSource = self
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        userIsSleeping = false
        for cell in collectionView.visibleCells as! [PhotoCollectionViewCell] {
            cell.parallax(offsetPoint: self.collectionView.contentOffset)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let indexPath = collectionView.indexPathsForVisibleItems.first else { return }
        collectionView.reloadData()
        userIsSleeping = true
        if indexPath.row == photos.count - 1  || indexPath.row == 0 {
            scrollToFirstItem(animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        let object = photos[indexPath.row]
        cell.configure(object: object)
        cell.linkDelegate = self
        return cell
    }
}


