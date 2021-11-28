//
//  PhotoCollectionView.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit


class PhotoCollectionView: UICollectionView {
    
    var layout = ScaleFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        setupCollectionView()
    }

    func setupCollectionView() {
        self.collectionViewLayout = layout
        self.isPagingEnabled = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCollectionView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

