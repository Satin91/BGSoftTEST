//
//  ImageResizer.swift
//  BGSoftTEST
//
//  Created by Артур on 29.11.21.
//

import UIKit


//MARK: Расширение с методом, который уменьшает размер фотографии в процентах

extension UIImage {
    
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
            let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
            let format = imageRendererFormat
            format.opaque = isOpaque
            return UIGraphicsImageRenderer(size: canvas, format: format).image {
                _ in draw(in: CGRect(origin: .zero, size: canvas))
            }
    }
}
