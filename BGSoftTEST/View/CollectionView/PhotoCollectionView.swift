//
//  PhotoCollectionView.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit

class PhotoCollectionView: UICollectionView {

    let layout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        setupCollectionView()
    }
    
    func setupLayout() {
        let width = self.bounds.width
        let height = self.bounds.height
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0//sideInset * 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func setupCollectionView() {
        self.collectionViewLayout = layout
        self.isPagingEnabled = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

