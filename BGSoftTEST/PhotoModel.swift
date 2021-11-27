//
//  PhotoModel.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit


class PhotoObject {
    
    var name : String!
    var image: UIImage!
    var model: PhotoModel!
    
    init(name: String, model: PhotoModel,image: UIImage ) {
        self.name = name
        self.image = image
        self.model = model
    }
}

struct PhotoModel: CustomStringConvertible {
    
    let name : String
    var colors: [String]
    var image: UIImage?
    let photo_url: String
    let user_name: String
    let user_url:  String
    
     init(dictionary: [String: Any], name: String, image: UIImage?) {
        self.colors    = dictionary["colors"] as? [String] ?? []
        self.photo_url = dictionary["photo_url"] as? String ?? ""
        self.user_name = dictionary["user_name"] as? String ?? ""
        self.user_url  = dictionary["user_url"] as? String ?? ""
        self.name      = name
        self.image     = image
    }
    var description: String {
        return "PhotoModel#: " + String(photo_url) + " - photo_url: " + user_name + " - user_name: " + user_url
    }
}




