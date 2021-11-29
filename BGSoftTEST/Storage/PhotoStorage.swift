//
//  PhotoModel.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import Foundation
import UIKit


class PhotoStorage {
    
    //: MARK: Кэш для фотографий
    
    static var imageCashe = NSCache<AnyObject,AnyObject>()
    
    //: MARK: Создает очередь для загрузки фотографий
    
    fileprivate func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    //: MARK: Загружает фотографию
    
    func loadPhoto(from url: String, completion: @escaping () -> Void) {
        guard let imageURL = URL(string: url) else { return }
        Queue.PhotoLoading(.userInitiated) { [weak self] in
            if PhotoStorage.imageCashe.object(forKey: url as NSString) == nil {
                self?.getData(from: imageURL) { data, response, error in
                    guard let data = data, error == nil else { return }
                    guard let image = UIImage(data: data)?.resized(withPercentage: 0.5) else { return }
                    PhotoStorage.imageCashe.setObject(image as UIImage, forKey: url as NSString)
                }
            }
        }
    }
    
    
    
    //MARK: Возвращает массиив с моделями фотографий
    
    func getPhotos() -> [PhotoModel]{
        var sortedPhotoCollection: [PhotoModel] = []
        do {
            if let file = URL(string: "http://dev.bgsoft.biz/task/credits.json") {
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
                    self.loadPhoto(from: url) {
                    }
                    model.imageURL = url
                    
                }
                
                
            } else {
            }
        } catch {
            print(error.localizedDescription)
        }
        let firstHalf = sortedPhotoCollection
        // Добавляет первый элемент в конец массива для того, чтобы с него перешагнуть на первый ( такой же )
        sortedPhotoCollection.append(sortedPhotoCollection.first!)
        let totalArray = firstHalf + sortedPhotoCollection
        for (index, value ) in totalArray.enumerated() {
            value.index = index
        }
                
        return totalArray
    }
}

extension UIImageView {
    func loadPhoto(imageUrl: String, completion: @escaping (Bool)-> Void ) {
        guard let url = URL(string: imageUrl)  else { return }
        
        if let image = PhotoStorage.imageCashe.object(forKey: imageUrl as NSString) as? UIImage {
            self.image = image
            return
        }
        Queue.AssignPhotoToCell(.userInteractive, complition: {  [weak self] in
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)?.resized(withPercentage: 0.5)
                PhotoStorage.imageCashe.setObject(image!, forKey: imageUrl as NSString)
                DispatchQueue.main.async {
                    self?.image = image
                    completion(true)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                    print(error)
                }
                
            }
        })
    }
}






