//
//  CompositionalLayout.swift
//  BGSoftTEST
//
//  Created by Артур on 1.12.21.
//

import UIKit



class CompositionalLayout: UICollectionViewLayout, UIScrollViewDelegate{
    
    var layout = UICollectionViewLayout()
    var photoCollectionView: UICollectionView?
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
        self.photoCollectionView = collectionView
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
        guard let collectionView = self.photoCollectionView else { return UICollectionViewLayout() }
        collectionView.alwaysBounceVertical = false
        
        let layout = UICollectionViewCompositionalLayout { [self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var item: NSCollectionLayoutItem!
            // Сама ячейка
            item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            if UIDevice.current.model == "iPad" {
                spacing = 45
            } else {
                spacing = 15
            }
            
            // Горизонтальная группа из двух ячеек
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitem: item, count: 2)
            horizontalGroup.interItemSpacing = NSCollectionLayoutSpacing.fixed(spacing)
            
            // Вертикальная группа состоящая из двух горизонтальных групп
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(collectionView.bounds.width - spacing * 2), heightDimension: .fractionalHeight(1.0)), subitem: horizontalGroup, count: 2)
            verticalGroup.interItemSpacing = NSCollectionLayoutSpacing.fixed(spacing)
            
            
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.interGroupSpacing = spacing * 2
            section.contentInsets = NSDirectionalEdgeInsets(top: spacing * 2, leading: spacing, bottom: spacing * 2, trailing: spacing * 5)
            section.orthogonalScrollingBehavior = .groupPaging
            
            // Так как у compositional layout нет связи с методами делегата scrollView требуется отправлять данные отсюда
            section.visibleItemsInvalidationHandler = { visibleItems, point, environment in
                sendFirstIndexPathInPage(at: point)
            }
            return section
        }
        return layout
    }
}
extension CompositionalLayout {
    
    func sendFirstIndexPathInPage(at compositionalPoint: CGPoint) {
        guard let collectionView = self.photoCollectionView else { return }
        let collectionWidth = collectionView.bounds.width
        var currentXPoint: CGFloat = 0
        if compositionalPoint.x >= currentXPoint + collectionWidth || compositionalPoint.x <= currentXPoint - collectionWidth {
            // Координаты верхней левой ячейки
            let pointForIndex = CGPoint(x: collectionWidth / 3, y: collectionView.bounds.height / 3)
            guard let index = collectionView.indexPathForItem(at: pointForIndex) else { return }
            currentXPoint = pointForIndex.x
            sendIndexDelegate.sendValueOf(firstIndexPath: index)
        }
        
    }
}
