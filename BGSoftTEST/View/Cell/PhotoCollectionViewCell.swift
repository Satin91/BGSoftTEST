//
//  PhotoCollectionViewCell.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell{
    
    static let identifier = "PhotoCell"
    let radius: CGFloat = 26
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
    }

    func configure(object: PhotoModel) {
        label.text   = object.user_name
        photoLink    = object.photo_url
        userLink     = object.user_url
        photo.loadPhoto(imageUrl: object.imageURL, completion: { completion in
                if completion == false {
                    self.photo.image = UIImage(systemName: "photo.fill")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 26))
                }
        })
    }
    
    @objc func followTheUserLink(_ button: UIButton) {
        guard let userLink = userLink else { return }
        linkDelegate.openWebViewController(link: userLink)
    }
    
    @objc func followThePhotoLink(_ button: UIButton) {
        guard let photoLink = photoLink else { return }
        linkDelegate.openWebViewController(link: photoLink)
    }
    
    func parallax(offsetPoint:CGPoint) {
        let factor: CGFloat = 0.2
        let offsetX = (offsetPoint.x - self.frame.origin.x) * factor
        let frame = photo.bounds
        let offsetFame = frame.offsetBy(dx: CGFloat(offsetX), dy: CGFloat(0))
        photo.frame = offsetFame
    }

    func setupView() {
        self.contentView.layer.cornerRadius = radius
        self.contentView.backgroundColor = .white
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(photo)
        self.contentView.addSubview(label)
        self.contentView.addSubview(stackView)
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
    
    func setupImageView() {
        photo = UIImageView(frame: self.bounds)
        photo.contentMode = .scaleAspectFill
    }
    
    func setShadow() {
        self.layer.cornerRadius = self.radius
        self.dropShadow(color: .black, offSet: CGSize(width: 0, height: 0) )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setShadow()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
