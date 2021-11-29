//
//  PhotoModel.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import Foundation
import UIKit



class PhotoStorage {
    
    let jsonFileURL = "http://dev.bgsoft.biz/task/credits.json"
    let queue = Queue()
    var ip = [ImageProvider]()
    //: MARK: Кэш для фотографий
    
    static var imageCashe = NSCache<AnyObject,AnyObject>()
    
    //: MARK: Создает очередь для асинхронной загрузки фотографий
    
    fileprivate func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    //: MARK: Загружает фотографию
    
    func loadPhoto(from url: String, completion: @escaping (UIImage) -> Void) {
        guard let imageURL = URL(string: url) else { return }
        if PhotoStorage.imageCashe.object(forKey: url as NSString) == nil {
            self.getData(from: imageURL) { data, response, error in
                guard let data = data, error == nil else { return }
                guard let image = UIImage(data: data)?.resized(withPercentage: 0.7) else { return }
                PhotoStorage.imageCashe.setObject(image as UIImage, forKey: url as NSString)
                   print(url)
                completion(image)
            }
        }
    }
    
    //MARK: Возвращает массиив с моделями фотографий
    
    func getPhotos() -> [PhotoModel]{
        var sortedPhotoCollection: [PhotoModel] = []
        
        
        do {
            if let file = URL(string: self.jsonFileURL) {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let object = json as? [String: Any] else { return [] }
                for dict in object {
                    let photoModel = PhotoModel(dictionary: dict.value as! [String:Any], name: dict.key)
                    sortedPhotoCollection.append(photoModel)
                }
                // Сортировка по имени
                sortedPhotoCollection.sort{ ($0.user_name < $1.user_name) }
                for model in sortedPhotoCollection {
                    
                    let url = "http://dev.bgsoft.biz/task/" + model.name + ".jpg"
                    
                    Queue.PhotoLoading(.utility, complition: {
                        self.loadPhoto(from: url) { image in
                        }
                    })
                   
//
//                    ip.append(ImageProvider(imageURLString: url, completion: { image in
//                        OperationQueue.main.addOperation {
//
//                        }
//                    }))
                    model.imageURL = url
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        //        for i in ip {
        //            i.start()
        //        }
        guard !sortedPhotoCollection.isEmpty else { return [] }
        let firstHalf = sortedPhotoCollection
        // Добавляет первый элемент в конец массива для того, чтобы с него перешагнуть на первый ( такой же )
        sortedPhotoCollection.append(sortedPhotoCollection.first!)
        let totalArray = firstHalf + sortedPhotoCollection
        return totalArray
    }
}

extension UIImageView {
    func assignPhoto(imageUrl: String, completion: @escaping (Bool)-> Void ) {
        guard URL(string: imageUrl) != nil else { return }
        if let image = PhotoStorage.imageCashe.object(forKey: imageUrl as NSString) as? UIImage {
            self.image = image
            return
        }
        DispatchQueue.global(qos: .userInteractive).async {
            PhotoStorage().loadPhoto(from: imageUrl) { img in
                PhotoStorage.imageCashe.setObject(img, forKey: imageUrl as NSString)
                DispatchQueue.main.async {
                    self.image = img
                    print("Completion \(imageUrl)")
                    completion(true)
                }
            }
        }
    }
}





