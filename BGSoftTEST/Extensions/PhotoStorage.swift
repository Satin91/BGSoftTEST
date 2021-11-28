//
//  PhotoModel.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import Foundation
import UIKit


class PhotoStorage {
    // Кэш для фотографий
    static var imageCashe = NSCache<AnyObject,AnyObject>()
    // Создает задачу для загрузки изображений
    fileprivate func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    // Загружает фотографии из очереди
    func loadPhoto(from url: String, completion: @escaping () -> Void) {
        guard let imageURL = URL(string: url) else { return }
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async { [self] in
            if PhotoStorage.imageCashe.object(forKey: url as NSString) == nil {
                
            getData(from: imageURL) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    
                    guard let image = UIImage(data: data) else { return }
                    PhotoStorage.imageCashe.setObject(image as UIImage, forKey: url as NSString)
                }
            }
        }
        }
    }
    
    // Возвращает массив с моделью для коллекции
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
        return firstHalf + sortedPhotoCollection
    }
    
    
}

extension UIImageView {
    func loadPhoto(imageUrl: String, completion: @escaping (Bool)-> Void ) {
        guard let url = URL(string: imageUrl)  else { return }
        
        if let image = PhotoStorage.imageCashe.object(forKey: imageUrl as NSString) as? UIImage {
            self.image = image
            return
        }
        DispatchQueue.global(qos: .userInteractive).async {  [weak self] in
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    PhotoStorage.imageCashe.setObject(image!, forKey: imageUrl as NSString)
                    self?.image = image
                    completion(true)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                    print(error)
                }
                
            }
        }
    }
}
