//
//  PhotoCollectionView.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import UIKit

class PhotoCollectionView: UICollectionView {

   // let layout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        setupCollectionView()
    }
    
    func setupLayout() {
        let width = self.bounds.width
        let height = self.bounds.height
        let sideInset: CGFloat = 30
        let cellWidth = width - (sideInset * 2)
        let cellHeight = height - (sideInset * 6)
        print(cellHeight)
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = sideInset * 2
      //  layout.sectionInset = UIEdgeInsets(top: sideInset * 4, left: sideInset, bottom: sideInset, right: sideInset)
      
    }
    
    var layout = ScaleFlowLayout()
    func setupCollectionView() {
    //    setupLayout()
        
        self.collectionViewLayout = layout
        self.isPagingEnabled = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCollectionView()
     //   setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

