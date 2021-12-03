//
//  ChangeLayout.swift
//  BGSoftTEST
//
//  Created by Артур on 3.12.21.
//

import UIKit

// MARK: Change layout

extension MainViewController {
  
    enum LayoutType {
        case composition
        case flow
    }
    
    // Добавление жеста
    func addPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:)))
        collectionView.addGestureRecognizer(pinchGesture)
    }
    
    // Метод, который обрабатывает жесты с условиями для смены layout
    @objc func pinch(_ gesture: UIPinchGestureRecognizer) {
        let begin: CGFloat = gesture.scale
        if gesture.state == .changed {
            if begin >= 1.2 {
                self.changeLayout(to: .flow)
            } else if begin <= 0.8{
                self.changeLayout(to: .composition)
            }
        }
    }
    
    // Упрощенная для использования функция с анимацией блюра
    func animateBlur(completion: ((Bool)-> Void)? ) {
        UIView.animate(withDuration: 0.3, animations: {
            self.blur.alpha = 1
        }, completion: completion)
    }
    
    func changeLayout(to: LayoutType) {
        switch to {
        case .composition:
            if self.compositionalLayoutIsUsing == false {
                self.compositionalLayoutIsUsing = true
                animateBlur { [weak self] complition in
                    guard let self = self else  { return }
                    guard let composLayout = self.composLayout else { return }
                    self.compositionalLayoutIsUsing = true
                    self.scaleLayout.invalidateLayout()
                    self.collectionView.setCollectionViewLayout(composLayout.layout, animated: false)
                    self.collectionView.scrollToItem(at: self.currentIndexPath, at: .centeredHorizontally, animated: false)
                    // Обновить данные чтобы все ячейки вышли из параллакс режима и не пропадали
                    self.collectionView.reloadData()
                }
            }
        case .flow:
            if self.compositionalLayoutIsUsing == true {
                self.compositionalLayoutIsUsing = false
                animateBlur { [weak self] complition in
                    guard let self = self else  { return }
                    self.compositionalLayoutIsUsing = false
                self.composLayout?.layout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(self.scaleLayout, animated: false)
                self.collectionView.scrollToItem(at: self.currentIndexPath, at: .centeredVertically, animated: false)
                }
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.blur.alpha = 0
        }
    }
}

