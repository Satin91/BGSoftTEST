//
//  CompositionalLayout.swift
//  BGSoftTEST
//
//  Created by Артур on 1.12.21.
//

import UIKit

protocol CompositionalFirstIndex {
    func sendValueOf(indexPath: IndexPath)
}

    
class CompositionalLayout: UICollectionViewLayout, UIScrollViewDelegate{
    
    var layout = UICollectionViewLayout()
    var collView: UICollectionView?
    var isLandscape: Bool = false {
        willSet {
            if newValue == true {
                self.spacing = 10
            }
        }
    }
    var spacing: CGFloat = 0
    init(collectionView: UICollectionView) {
        super.init()
        self.collView = collectionView
        self.layout = createLayout()
    }
    var sendIndexDelegate: CompositionalFirstIndex!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Ssssss")
    }
    
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var trailingItem: NSCollectionLayoutItem!
            // Сама ячейка
            trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
           
            if UIDevice.current.model == "iPad" {
                spacing = 45
            } else {
                spacing = 15
            }
//
            
            // Горизонтальная группа из двух ячеек
            
            let subGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitem: trailingItem, count: 2)
            subGroup.interItemSpacing = NSCollectionLayoutSpacing.fixed(spacing)
    
            // Вертикальная группа состоящая из двух горизонтальных групп
            
            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(self.collView!.bounds.width - spacing * 2), heightDimension: .fractionalHeight(1.0)), subitem: subGroup, count: 2)
            trailingGroup.interItemSpacing = NSCollectionLayoutSpacing.fixed(spacing)
 
            collView?.alwaysBounceVertical = false
            let section = NSCollectionLayoutSection(group: trailingGroup)
            section.interGroupSpacing = spacing * 2
            section.contentInsets = NSDirectionalEdgeInsets(top: spacing * 2, leading: spacing, bottom: spacing * 2, trailing: spacing * 5)
            section.orthogonalScrollingBehavior = .groupPaging
            
            section.visibleItemsInvalidationHandler = { visibleItems, point, environment in
                sendFirstIndexPathInPage(at: point)
                
        }
            return section
    }
        return layout
}
}
extension CompositionalLayout {
    
    func sendFirstIndexPathInPage(at point: CGPoint) {
        
        let width = collView?.bounds.width
        
        var currentXPoint: CGFloat = 0
        
        
    if point.x >= currentXPoint + width! || point.x <= currentXPoint - width! {
        // Координаты верхней левой ячейки
        let point = CGPoint(x: collView!.bounds.width / 3, y: self.collView!.bounds.height / 3)
        guard let index = collView?.indexPathForItem(at: point) else { return }
        currentXPoint = point.x
        sendIndexDelegate.sendValueOf(indexPath: index)
    }
        
    }
}
