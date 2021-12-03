//
//  LayoutProtocol.swift
//  BGSoftTEST
//
//  Created by Артур on 1.12.21.
//

import UIKit



protocol LayoutSize: UICollectionViewLayout {
    var isCompact: Bool { get set }
    var isLandscape: Bool { get set }
    var spacing: CGFloat { get set }
    var height: CGFloat { get set }
    var width: CGFloat { get set }
    func iPhoneValues()
    func iPadValues()
}


extension LayoutSize {
    
    func iPhoneValues() {
        guard let collectionView = collectionView else { print("Collection view = nil"); return }
        self.height = collectionView.bounds.height * 0.7
        self.width = collectionView.bounds.width
        switch isLandscape {
        case true:
            spacing = ItemSpacing.iPhone.landscape.rawValue
        case false:
            spacing = ItemSpacing.iPhone.portrait.rawValue
        }
    }
    
    func iPadValues() {
        switch isCompact {
        case true :
            
            spacing = ItemSpacing.iPad.compact.rawValue
            guard let collectionView = collectionView else { print("Collection view = nil"); return }
            self.width = collectionView.bounds.width
            self.height = collectionView.bounds.height * 0.5
            
        case false :
            
            guard let collectionView = collectionView else { print("Collection view = nil"); return }
            self.height = collectionView.bounds.height * 0.7
            self.width = collectionView.bounds.width
            switch isLandscape {
            case true:
                spacing = ItemSpacing.iPad.landscape.rawValue
            case false:
                spacing = ItemSpacing.iPad.portrait.rawValue
            }
        }
    }
    
}


