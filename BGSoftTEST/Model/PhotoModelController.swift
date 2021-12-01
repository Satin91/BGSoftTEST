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
    // MARK: Очередь для загрузки фотографий
    
    
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
                print("image did load \(object.imageURL)")
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
                    guard counter <= 5 else { break }
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
        self.photos = sortedPhotoCollection
    }
    
    //MARK: Метод создает "бесконечный" массив
    
    func createEndlessСarousel() -> [PhotoModel] {
        var secondHalf = photos
        let firstHalf = secondHalf
        secondHalf.append(photos.first!)
        let totalArray = firstHalf + secondHalf
        return totalArray
    }
    
}

extension UIImageView {
    func loadPhoto(imageUrl: String, completion: @escaping (Bool)-> Void ) {
        
        if let photo = Networking.imageCashe.object(forKey: imageUrl as NSString) as? UIImage  {
            self.image = photo
            return
        } else {
            let networking = Networking()
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

