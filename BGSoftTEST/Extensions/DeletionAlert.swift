//
//  Alert.swift
//  BGSoftTEST
//
//  Created by Артур on 1.12.21.
//

import UIKit


//MARK: Расширение для отображения алерта с удалением ячеек

extension MainViewController {
    
    // MARK: Поиск парных фотографий
    
    fileprivate func findDuplicates(row: Int) -> [IndexPath] {
        var indexes: [IndexPath] = []
        for i in stride(from: row, to: self.photos.count  * factor, by: self.photos.count ) {
            indexes.append(IndexPath(row: i, section: 0))
        }
        return indexes
    }
    
    // MARK: Удаление ячеек
    
    func showDeletionAlert(row: Int) {
        let alertController = UIAlertController(title: "Удалить фото?", message: "Фотография будет удалена", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Удалить?", style: .destructive) { _ in
            let scrollIndex = IndexPath(item: self.currentIndexPath.row - (self.findDuplicates(row: row).count / 2), section: 0)
            if self.compositionalLayoutIsUsing {
                self.collectionView.scrollToItem(at:  scrollIndex, at: .centeredVertically, animated: true)
            }
            self.collectionView.performBatchUpdates {
                self.collectionView.deleteItems(at: self.findDuplicates(row: row))
                 self.photos.remove(at: row)
            } 
            
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
