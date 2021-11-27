//
//  PhotoCollectionViewCell.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell{
    func openPhoto(photo: UIImage) {
        self.photo.image = photo
    }
    
    
    var photo: UIImageView!
    static let identifier = "PhotoCell"
//    private var image : UIImage {
//        get  {
//            guard let image = photo.image  else {
//                return UIImage(systemName: "trash")!
//            }
//            return image
//        } set {
//            self.photo.image = newValue
//        }
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        self.clipsToBounds = true
        setupImageView()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
      //  image = UIImage(systemName: "trash")!
    }
    
    
    
    func set(photo: PhotoObject) {
        let urlString = "http://dev.bgsoft.biz/task/" + photo.name + ".jpg"
        let photoURL = URL(string: urlString)!
        print(urlString)
      //  photo.downloadImage(from: photoURL)
     //   photo.openPhoto = self
        
        
        DispatchQueue.main.async {
            self.photo.image = photo.image
        }
        
        
//        
//        
//        let queue = DispatchQueue.global(qos:.utility)
//        queue.async {
//            guard let imageData = try? Data(contentsOf: photoURL) else { return }
//
//            DispatchQueue.main.async {
//                self.image = UIImage(data: imageData)!
//            }
//
//        }
        
   
        
    }
    func setupImageView() {
        self.photo = UIImageView(frame: self.bounds)
        self.photo.contentMode = .scaleAspectFill
        self.addSubview(photo)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


