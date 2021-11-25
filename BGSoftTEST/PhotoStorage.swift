//
//  PhotoModel.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import Foundation





class PhotoStorage {
    
    

    
        
    
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
                        print(dc2.user_name)
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


