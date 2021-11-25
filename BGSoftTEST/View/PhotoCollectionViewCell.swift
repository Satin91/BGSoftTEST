//
//  PhotoCollectionViewCell.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var photo: UIImageView!
    static let identifier = "PhotoCell"
    var image : UIImage {
        get  {
            guard let image = photo.image  else {
                return UIImage(systemName: "trash")!
            }
            return image
        } set {
            self.photo.image = newValue
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        self.clipsToBounds = true
        setupImageView()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        image = UIImage(systemName: "trash")!
    }
    
    
    func set(photo: PhotoObject) {
        let urlString = "http://dev.bgsoft.biz/task/" + photo.name + ".jpg"
        let photoURL = URL(string: urlString)!
        print(urlString)
        self.photo.downloaded(from: photoURL)
        if let filePath = Bundle.main.path(forResource: "imageName", ofType: "jpg"), let image = UIImage(contentsOfFile: filePath) {
            //photo.contentMode = .scaleAspectFit
            self.photo.image = image
        }
        
        
        
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

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
