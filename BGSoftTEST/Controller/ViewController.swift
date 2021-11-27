//
//  ViewController.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit

class ViewController: UIViewController {
    
    var collectionView: PhotoCollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section,PhotoObject>! = nil
    let photoStorage = PhotoStorage()
    private var photos  = [PhotoObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = self.photoStorage.getPhotos() // получение массива структур со всеми данными
        setupCollectionView()
        self.view.backgroundColor = .systemRed
    }
    
    
    func setupCollectionView() {
        collectionView = PhotoCollectionView(frame: self.view.bounds)
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .gray
        
        let cellRegistration = PhotoCollectionView.CellRegistration<PhotoCollectionViewCell,PhotoObject> { (cell, indexPath, item) in
            cell.photo.image = item.image
            ImageCache.publicCache.load(url: item.url as NSURL, item: item) { fetchedPhoto, image in
                guard let image = image, image != fetchedPhoto.image else { return }
                var updatedSnapshot = self.dataSource.snapshot()
                if let datasourceIndex = updatedSnapshot.indexOfItem(fetchedPhoto) {
                    let item = self.photos[datasourceIndex]
                    item.image = image
                    updatedSnapshot.reloadItems([item])
                    self.dataSource.apply(updatedSnapshot, animatingDifferences: true)
                }
            }
        }
        dataSource = UICollectionViewDiffableDataSource<Section, PhotoObject>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: PhotoObject) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        //collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate   = self
        collectionView.dataSource = self
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        var object = photos[indexPath.row]
        //        let image  = self.images[indexPath.row]
        //  cell.photo.image = image
        cell.set(photo: object)
        return cell
    }
    
    
}
