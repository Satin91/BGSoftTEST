//
//  PhotoModel.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import Foundation
import UIKit


class Networking {
    static var imageCashe = NSCache<AnyObject,AnyObject>()
    // Создает задачу для загрузки изображений
    fileprivate func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    // Загруэает изображение и присваивает его экземпляру PhotoModel
    func downloadImage(from url: URL, completion: @escaping () -> Void) {
        let queue = DispatchQueue.global(qos: .background)
        queue.async { [self] in
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
               
                DispatchQueue.main.async() {
                    guard let image = UIImage(data: data) else { return }
                    Networking.imageCashe.setObject(image as UIImage, forKey: url.path as NSString)
                    //model.image = image
                    
                }
            }
        }
       
    }
}
