//
//  DropShadow.swift
//  BGSoftTEST
//
//  Created by Артур on 28.11.21.
//

import UIKit


//MARK: Тень для ячейки

extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.4, offSet: CGSize, radius: CGFloat = 5, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 26).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
