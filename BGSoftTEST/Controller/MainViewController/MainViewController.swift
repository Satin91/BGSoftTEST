//
//  ViewController.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit

class MainViewController: UIViewController {
    
    
    var collectionView: PhotoCollectionView!
    let photoStorage = Networking()
    
    private var photos  = [PhotoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos() 
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
    

    func getPhotos() {
        var modelForSorted: [PhotoModel] = []
        do {
            if let file = URL(string: "http://dev.bgsoft.biz/task/credits.json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let object = json as? [String: Any] else { return }
                
                for dict in object {
                    let photoModel = PhotoModel(dictionary: dict.value as! [String:Any], name: dict.key)
                    modelForSorted.append(photoModel)
                    print(modelForSorted.forEach({ Mode in
                    }))
                }
                // Сортировка по имени
                modelForSorted.sort{ ($0.user_name < $1.user_name) }
                
                for model in modelForSorted {
                    let url = "http://dev.bgsoft.biz/task/" + model.name + ".jpg"
                    let imageUrl = URL(string: url)
                    photoStorage.downloadImage(from: imageUrl!, model: model, completion: {
                        self.photos.append(model)
                        self.collectionView.reloadData()
                    })
                }
            } else {
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        let object        = photos[indexPath.row]
        cell.label.text   = object.user_name
        cell.photo.image  = object.image
        cell.photoLink    = object.photo_url
        cell.userLink     = object.user_url
        cell.linkDelegate = self
        return cell
    }
}


