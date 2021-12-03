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
    
    // MARK: Загружает фотографии стоящие рядом с той, которая перед глазами
    
    func loadAdjacentPhotos(currentIndex: IndexPath, from array: [PhotoModel] ) {
        var location: Int = 0
        var lenght : Int = 10
        
        if currentIndex.row - 4 >= 0 {
            location = currentIndex.row - 4
        } else {
            location = currentIndex.row
        }
        if currentIndex.row + 4 <= array.count - 1 {
            lenght = currentIndex.row + 4
        } else {
            lenght = array.count - 1
        }
        
        array[location...lenght].forEach { object in
            networking.downloadImage(from: object.imageURL) { image in
            }
        }
    }
    
    
    // MARK: Создает массив моделей / парсит данные
    
    func getModelArray(){
        var sortedPhotoCollection: [PhotoModel] = []
        
        do {
            if let file = URL(string: jsonFileURL) {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let object = json as? [String: Any] else { return }
                var counter = 0
                for dict in object {
                    guard counter <= 50 else { break }
                    let photoModel = PhotoModel(dictionary: dict.value as! [String:Any], name: dict.key)
                    let url = heading + dict.key + ".jpg"
                    photoModel.imageURL = url
                    sortedPhotoCollection.append(photoModel)
                    
                    
                    counter += 1
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
    
}

extension UIImageView {
    
    //MARK: Расширение для загрузки изображения. Если то еще не загружено, запускается очередь с completion блоком который служит уведомлением для коллекции о том, что нужно обновить данные
    
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

