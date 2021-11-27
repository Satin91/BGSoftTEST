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
    
    var dataSource: UICollectionViewDataSource!
    private var photos  = [PhotoObject]()
    private var photos2 = [UIImage]()
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
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL,name: String, model: PhotoModel) {
   //     print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
       //     print(response?.suggestedFilename ?? url.lastPathComponent)
      //      print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                guard let self = self else { return }
                guard let image = UIImage(data: data) else { return }
                self.photos.append(PhotoObject(name: name, model: model, image: image))
            //    self.photos2.append(image)
                self.collectionView.reloadData()

                print(image)
            }
        }
    }
   
    func getPhotos() {
        var modelForSorted: [PhotoModel] = []
        do {
            if let file = URL(string: "http://dev.bgsoft.biz/task/credits.json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
              
                    for dict in object {
                        let photoModel = PhotoModel(dictionary: dict.value as! [String:Any], name: dict.key, image: nil)
                        modelForSorted.append(photoModel)
                    //    downloadImage(from: imageURL!, name: dict.key, model: photoModel)
                        print(photos)
                        print("url is \(photos.count)")
                    }
                    modelForSorted.sort{ model1, model2 in
                        return model1.user_name > model2.user_name
                    }
                    for model in modelForSorted {
                        
                    }
                }
            } else {
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    var indexpath: IndexPath?
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //Begin asynchronously fetching data for the requested index paths.
        
//
//        for indexPath in indexPaths {
//            guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell else { return }
//            print(indexPath.row)
//
//            //let model = models[indexPath.row]
//            //asyncFetcher.fetchAsync(model.identifier)
//        }
    }
    
    
    
    //    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    //
    //    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.reloadData()
        //collectionView.reloadItems(at: [self.indexpath!])
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        var object = photos[indexPath.row]
        self.indexpath = indexPath
        //        let image  = self.images[indexPath.row]
        cell.photo.image = object.image
       // cell.set(photo: object)
        return cell
    }
    
    
}
