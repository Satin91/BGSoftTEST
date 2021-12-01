//
//  LayoutProtocol.swift
//  BGSoftTEST
//
//  Created by Артур on 1.12.21.
//

import UIKit



protocol LayoutSize: UICollectionViewLayout {
    var isLandscape: Bool { get set }
    var spacing: CGFloat { get set }
    var height: CGFloat { get set }
}

protocol iPadLayout: LayoutSize {
    var isCompact: Bool { get set }
    func iPadLayout()
}


extension iPadLayout {
    
    func iPadLayout() {
        switch isCompact {
        case true :
            
            spacing = ItemSpacing.iPad.compact.rawValue
            guard let height = collectionView?.bounds.height else { print("Collection view = nil"); return }
            self.height = height * 0.5
            
        case false :
            
            guard let height = collectionView?.bounds.height else { print("Collection view = nil"); return }
            self.height = height * 0.7
            
            switch isLandscape {
            case true:
                spacing = ItemSpacing.iPad.landscape.rawValue
            case false:
                spacing = ItemSpacing.iPad.portrait.rawValue
            }
        }
    }
}

protocol iPhoneLayout: LayoutSize {
    func iPhoneLayout()
}

extension iPhoneLayout {
    func iPhoneLayout() {
        guard let height = collectionView?.bounds.height else { print("Collection view = nil"); return }
        self.height = height * 0.7
        switch isLandscape {
        case true:
            spacing = ItemSpacing.iPhone.landscape.rawValue
        case false:
            spacing = ItemSpacing.iPhone.portrait.rawValue
        }
    }
}

