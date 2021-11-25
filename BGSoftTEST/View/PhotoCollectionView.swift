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
        setupLayout()
        setupCollectionView()
    }
    
    func setupLayout() {
        let width = self.bounds.width
        let height = self.bounds.height
        let sideInset: CGFloat = 26
        let cellWidth  = width  - (sideInset * 2)
        let cellHeight = height - (sideInset * 2)
        
        layout.itemSize = CGSize(width: width, height: height)
        
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = sideInset * 2
        layout.sectionInset = UIEdgeInsets(top: sideInset, left: sideInset, bottom: sideInset, right: sideInset)
    }
    func setupCollectionView() {
        self.collectionViewLayout = layout
        self.isPagingEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension PhotoCollectionView: UICollectionViewDelegateFlowLayout {
    
    
    
}
