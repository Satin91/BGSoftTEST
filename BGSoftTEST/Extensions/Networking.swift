//
//  PhotoModel.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import Foundation
import UIKit


class Networking {
    
    // Создает задачу для загрузки изображений
    fileprivate func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    // Загруэает изображение и присваивает его экземпляру PhotoModel
    func downloadImage(from url: URL, model: PhotoModel,  completion: @escaping () -> Void) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { 
                guard let image = UIImage(data: data) else { return }
                model.image = image
                completion()
            }
        }
    }
}
