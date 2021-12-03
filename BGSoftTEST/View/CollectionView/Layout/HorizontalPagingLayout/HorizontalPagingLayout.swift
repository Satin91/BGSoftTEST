//
//  ZoomLayout.swift
//  BGSoftTEST
//
//  Created by Артур on 28.11.21.
//

import UIKit








class HorizontalPagingLayout: UICollectionViewFlowLayout, LayoutSize {
    
    
    // MARK: Свойства протокола
    
    var width: CGFloat = 0.0
    
    var fourItems: Bool = false
    
    var isCompact: Bool = false
    
    var isLandscape: Bool = false
    
    var spacing: CGFloat = 0.0
    
    var height: CGFloat = 0.0
    
    var multitasking: Bool = false
    
    // MARK: Свойства класса
    
    var activeDistance: CGFloat = 390
    
    let zoomFactor: CGFloat = 0.15
    
    private let alpha: CGFloat = 0.7
    

    override func prepare() {
        print(height)
        
        if UIDevice.current.model == "iPad" {
            iPadValues()
        } else {
            iPhoneValues()
        }
        
        calculateLayout()
        super.prepare()
    }
    
    
    // Рассчет лейаута на основании свойств протокола
    func calculateLayout() {
        guard let collectionView = collectionView else { fatalError() }
        self.activeDistance = collectionView.bounds.width
        scrollDirection = .horizontal
        minimumLineSpacing = spacing * 2
        sectionInset = UIEdgeInsets(top: 50, left: spacing, bottom: 50, right: spacing)
        itemSize = CGSize(width: width - (spacing * 2), height: height )
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let rectAttributes = super.layoutAttributesForElements(in: rect)!.map{ $0.copy() as! UICollectionViewLayoutAttributes }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
        
        // Увеличить масштаб ячейки, когда та достигла центра
        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            self.alphaBlending(attributes: attributes, collectionView: collectionView)
            
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = distance / activeDistance
            
            if distance.magnitude < activeDistance {
                let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
                
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                
                attributes.zIndex = Int(zoom.rounded())
            }
        }
        
        return rectAttributes
    }
    
    func alphaBlending(attributes: UICollectionViewLayoutAttributes, collectionView: UICollectionView) {
        
        let collectionCenter = collectionView.bounds.size.width / 2
        let offset = collectionView.contentOffset.x
        let normalizedCenter = attributes.center.x - offset
        
        let maxDistance = itemSize.width + minimumLineSpacing
        let distanceFromCenter = min(collectionCenter - normalizedCenter, maxDistance)
        let ratio = (maxDistance - abs(distanceFromCenter)) / maxDistance
        
        let alpha = ratio * (1 - alpha) + alpha
        attributes.alpha = alpha
    }

    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
        return true
    }
    
    
}
