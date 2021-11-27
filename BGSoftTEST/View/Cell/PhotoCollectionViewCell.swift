//
//  PhotoCollectionViewCell.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell{
   
    static let identifier = "PhotoCell"
   
    var photo: UIImageView!
    var stackView = UIStackView()
    var linkDelegate: FollowTheLink!
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.font = .systemFont(ofSize: 34)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var userLinkButton: UIButton!
    var photoLinkButton: UIButton!
    
    var userLink: String? {
        willSet {
            self.userLinkButton.setTitle(newValue, for: .normal)
        }
    }
    var photoLink: String? {
        willSet {
            self.photoLinkButton.setTitle(newValue, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupButtons()
        setupView()
        constraints()
    }
   
    func setupButtons() {
        self.userLinkButton = UIButton(frame: .zero)
        self.userLinkButton.addTarget(self, action: #selector(followTheUserLink(_:)), for: .touchUpInside)
        self.userLinkButton.titleLabel?.font = .systemFont(ofSize: 10)
        self.userLinkButton.setTitleColor(.white, for: .normal)
        
        self.photoLinkButton = UIButton(frame: .zero)
        self.photoLinkButton.addTarget(self, action: #selector(followThePhotoLink(_:)), for: .touchUpInside)
        self.photoLinkButton.titleLabel?.font = .systemFont(ofSize: 10)
        self.photoLinkButton.setTitleColor(.white, for: .normal)
    }
    
    @objc func followTheUserLink(_ button: UIButton) {
        guard let userLink = userLink else { return }
        linkDelegate.openWebViewController(link: userLink)
    }
    
    @objc func followThePhotoLink(_ button: UIButton) {
        guard let photoLink = photoLink else { return }
        linkDelegate.openWebViewController(link: photoLink)
    }
    
    func setupView() {
        self.addSubview(photo)
        self.addSubview(label)
        self.addSubview(userLinkButton)
        self.addSubview(stackView)
        self.clipsToBounds = true
    }
    
    func setupImageView() {
        self.photo = UIImageView(frame: self.bounds)
        self.photo.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


