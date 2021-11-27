//
//  PhotoModel.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit

enum Section {
    case main
}

class PhotoObject: Hashable {
    var name : String!
    var model: PhotoModel!
    var image: UIImage!
    let url: URL!
    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func == (lhs: PhotoObject, rhs: PhotoObject) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    init(name: String, model: PhotoModel,image: UIImage, url: URL ) {
        self.name = name
        self.image = image
        self.model = model
        self.url = url
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

func download(url: URL, toFile file: URL, completion: @escaping (Error?) -> Void) {
    // Download the remote URL to a file
    let task = URLSession.shared.downloadTask(with: url) {
        (tempURL, response, error) in
        // Early exit on error
        guard let tempURL = tempURL else {
            completion(error)
            return
        }

        do {
            // Remove any existing document at file
            if FileManager.default.fileExists(atPath: file.path) {
                try FileManager.default.removeItem(at: file)
            }

            // Copy the tempURL to file
            try FileManager.default.copyItem(
                at: tempURL,
                to: file
            )

            completion(nil)
        }

        // Handle potential file system errors
        catch let fileError {
            completion(error)
        }
    }

    // Start the download
    task.resume()
}


