//
//  PhotoModel.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import Foundation
import UIKit


class PhotoModelController {
    
    
    private let jsonFileURL = "http://dev.bgsoft.biz/task/credits.json"
    private let heading     = "http://dev.bgsoft.biz/task/"
    
    public var photos: [PhotoModel] = []
    
    private let networking = Networking()
    
    init() {
        self.getModelArray()
    }
    

    
    
    // Создает массив моделей / парсит данные
    func getModelArray(){
        var sortedPhotoCollection: [PhotoModel] = []
        
        do {
            if let file = URL(string: jsonFileURL) {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let object = json as? [String: Any] else { return }
                for dict in object {
                    let photoModel = PhotoModel(dictionary: dict.value as! [String:Any], name: dict.key)
                    let url = heading + dict.key + ".jpg"
                    photoModel.imageURL = url
                    sortedPhotoCollection.append(photoModel)
                }
                // Сортировка по имени
                sortedPhotoCollection.sort{ ($0.user_name < $1.user_name) }
            }
        } catch {
            print(error.localizedDescription)
        }
        print(sortedPhotoCollection.count)
        self.photos = sortedPhotoCollection
    }
    
    // Загружает фотографии стоящие по соседству с той, которая перед глазами
    func loadAdjacentPhotos(currentIndex: Int, from array: [PhotoModel] ) {
        var location: Int = 0
        var lenght : Int = 10
        
        if currentIndex - 4 >= 0 {
            location = currentIndex - 4
        } else {
            location = currentIndex
        }
        if currentIndex + 4 <= array.count - 1 {
            lenght = currentIndex + 4
        } else {
            lenght = array.count - 1
        }
        
        array[location...lenght].forEach { object in
            networking.downloadImage(from: object.imageURL) { image in
            }
        }
    }
}

// Расширение для загрузки изображения. Если то еще не загружено, запускается очередь с completion блоком который служит уведомлением для коллекции о том, что нужно обновить данные

extension UIImageView {
    
    func loadPhoto(imageUrl: String, completion: @escaping (Bool)-> Void ) {
        let networking = Networking()
        
        if let photo = Networking.imageCashe.object(forKey: imageUrl as NSString) as? UIImage  {
            self.image = photo
            return
        } else {
            
            networking.downloadImage(from: imageUrl) { image in
                guard let image = image  else {
                    return
                }
                DispatchQueue.main.async {
                    self.image = image
                    completion(true)
                }
            }
        }
        
    }
}

