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
    var imageCenterXLayoutConstraint: NSLayoutConstraint!
    
    var parallaxOffset: CGFloat = 0 {
        willSet {
            imageCenterXLayoutConstraint.constant = parallaxOffset
        }
    }
    

    
    var userLinkButton: UIButton!
    var photoLinkButton: UIButton!
    
    var userLink: String? {
        willSet {
            userLinkButton.setTitle(newValue, for: .normal)
        }
    }
    var photoLink: String? {
        willSet {
            photoLinkButton.setTitle(newValue, for: .normal)
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
        userLinkButton = UIButton(frame: .zero)
        userLinkButton.addTarget(self, action: #selector(followTheUserLink(_:)), for: .touchUpInside)
        userLinkButton.titleLabel?.font = .systemFont(ofSize: 10)
        userLinkButton.setTitleColor(.white, for: .normal)
        
        photoLinkButton = UIButton(frame: .zero)
        photoLinkButton.addTarget(self, action: #selector(followThePhotoLink(_:)), for: .touchUpInside)
        photoLinkButton.titleLabel?.font = .systemFont(ofSize: 10)
        photoLinkButton.setTitleColor(.white, for: .normal)
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
        self.clipsToBounds = true
        self.layer.cornerRadius = 26
        addSubview(photo)
        addSubview(label)
        addSubview(userLinkButton)
        addSubview(stackView)
        
    }
    func setupImageView() {
        photo = UIImageView(frame: self.bounds)
        photo.contentMode = .scaleAspectFill
        //photo.layer.cornerRadius = 26
        //photo.clipsToBounds = false
    }
    func setShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 0)
        layer.shadowRadius  = 10
        layer.shadowOpacity = 0.4
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setShadow()
    }
    
    func updateParallaxOffset(collectionView bounds: CGRect) {
        let center = CGPoint(x: bounds.midX, y: bounds.maxY)
        let offsetFromCenter = CGPoint(x: center.x - self.center.x, y: center.y - self.center.y)
        let maximumHorizontalOffset = bounds.width / 2 + self.bounds.width / 2
        let scaleFactor = 40 / maximumHorizontalOffset
        parallaxOffset = -offsetFromCenter.y * scaleFactor 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


