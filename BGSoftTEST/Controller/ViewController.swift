//
//  ViewController.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit

class ViewController: UIViewController {

    var collectionView: PhotoCollectionView!
    let photoStorage = PhotoStorage()
    var store: [PhotoObject] = []
    // Фото для того чтобы они не обновлялись постоянно при скроле
    var images: [UIImage] = [] {
        willSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
           
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            self.store = self.photoStorage.getPhotos() // получение массива структур со всеми данными
            self.images = self.photoStorage.images
            
        }
        setupCollectionView()
        self.view.backgroundColor = .systemRed
        
        
    }
    
   
    func setupCollectionView() {
        collectionView = PhotoCollectionView(frame: self.view.bounds)
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .gray
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate   = self
        collectionView.dataSource = self
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        let object = store[indexPath.row]
        let image  = self.images[indexPath.row]
        cell.photo.image = image
      //  cell.set(photo: object)
        return cell
    }
    
    
}
