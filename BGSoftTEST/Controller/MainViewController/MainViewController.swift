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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        photos = photoStorage.getPhotos()
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
        for cell in collectionView.visibleCells as! [PhotoCollectionViewCell] {
            cell.parallax(offsetPoint: self.collectionView.contentOffset)
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


