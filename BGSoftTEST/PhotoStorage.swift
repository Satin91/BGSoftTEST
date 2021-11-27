//
//  PhotoModel.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import Foundation
import UIKit





class PhotoStorage {
    
    

    
    var images: [UIImage] = []
    
    func getPhotos() -> [PhotoObject] {
        var returnedObject: [PhotoObject] = []
        do {
            if let file = URL(string: "http://dev.bgsoft.biz/task/credits.json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    for dict in object {
                        let dc2 = PhotoModel(dictionary: dict.value as! [String:Any])
                        let object = PhotoObject(name: dict.key, model: dc2)
                        returnedObject.append(object)
                        let imageURL = "http://dev.bgsoft.biz/task/" + dict.key + ".jpg"
                            let imagerrr = URL(string: imageURL)
                        
                        print(object.name)
                      
                    }
                }
            } else {
            }
        } catch {
            print(error.localizedDescription)
        }
        return returnedObject
    }
    
    var photos = [PhotoObject]()

}
//mutating func getImage() {
//    let imageURL = "http://dev.bgsoft.biz/task/" + name + ".jpg"
//    let imagerrr = URL(string: imageURL)
//
//    guard let imageData = try? Data(contentsOf: imagerrr!) else { return }
//        let image2 = UIImage(data: imageData)
//    image = image2!
//}

