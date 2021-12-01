//
//  Networking.swift
//  BGSoftTEST
//
//  Created by Артур on 1.12.21.
//

import UIKit


class Networking {
    
    var queueURLArray: [String] = []
    
    static var imageCashe = NSCache<AnyObject,AnyObject>()
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void ) {
        // Запрещает загружать копию
        guard !queueURLArray.contains(url) else { return }
        queueURLArray.append(url)
        Queue.PhotoLoading(.userInitiated) {
            let imageURL = URL(string: url)
            self.getData(from: imageURL!) { data, response, error in
                guard let data = data, error == nil else { return }
                guard let image = UIImage(data: data) else { return }
                Networking.imageCashe.setObject(image.resized(withPercentage: 0.5)!, forKey: url as NSString)
                completion(image)
            }
        }
    }
}
