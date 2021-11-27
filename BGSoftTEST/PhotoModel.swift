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
    var colors: [String]
    let photo_url: String
    let user_name: String
    let user_url:  String
    
    init(dictionary: [String: Any]) {
        self.colors = dictionary["colors"] as? [String] ?? []
        self.photo_url = dictionary["photo_url"] as? String ?? ""
        self.user_name = dictionary["user_name"] as? String ?? ""
        self.user_url  = dictionary["user_url"] as? String ?? ""
    }
    var description: String {
        return "PhotoModel#: " + String(photo_url) + " - photo_url: " + user_name + " - user_name: " + user_url
    }
}



