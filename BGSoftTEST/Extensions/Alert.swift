//
//  Alert.swift
//  BGSoftTEST
//
//  Created by Артур on 1.12.21.
//

import UIKit

extension MainViewController {
    
    
    // MARK: Поиск парных фотографий
    
    fileprivate func findAndRemoveItems(row: Int) -> [IndexPath] {
        var indexes: [IndexPath] = []

        // Получает индексы всех одинаковых фотографий
        for i in stride(from: row, to: self.photos.count  * factor, by: self.photos.count ) {
            indexes.append(IndexPath(row: i, section: 0))
        }
        return indexes
    }
    
    // MARK: Удаление ячеек
    
    func showAlert(row: Int) {
        
        let alertController = UIAlertController(title: "Удалить фото?", message: "Фотография будет удалена", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Удалить?", style: .destructive) { _ in [self]
            let scrollIndex = IndexPath(item: self.currentIndexPath.row - (self.findAndRemoveItems(row: row).count / 2), section: 0)
            if self.compositionalLayoutIsUsing {
                self.collectionView.scrollToItem(at:  scrollIndex, at: .centeredVertically, animated: true)
            }
            self.collectionView.performBatchUpdates {
                self.collectionView.deleteItems(at: self.findAndRemoveItems(row: row))
                
                 self.photos.remove(at: row)
            } 
            
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
