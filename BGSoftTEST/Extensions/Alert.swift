//
//  Alert.swift
//  BGSoftTEST
//
//  Created by Артур on 1.12.21.
//

import UIKit

extension MainViewController {
    
    
    // MARK: Поиск парных фотографий
    
    fileprivate func findAndRemoveItems(name: String) -> [IndexPath] {
        var indexes: [IndexPath] = []
        for (index,value) in self.photos.enumerated() {
            if value.name == name {
                indexes.append(IndexPath(item: index, section: 0))
            }
        }
        print("removing indexes is \(indexes.count)")
       
        return indexes
    }
  
    // MARK: Удаление ячеек
    
    func showAlert(name: String) {
        
        let alertController = UIAlertController(title: "Удалить фото?", message: "Фотография будет удалена", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Удалить?", style: .destructive) { _ in
           
            self.collectionView.performBatchUpdates {
                
                self.collectionView.deleteItems(at: self.findAndRemoveItems(name: name))
                self.photoStorage.photos.removeAll { photo in
                    print("remove this photo \(photo.name)")
                    return photo.name == name
                }
                self.photos = self.photoStorage.createEndlessСarousel()
              
            } completion: { [self] completion in
              //  collectionView.reloadData()
                collectionView.reloadItems(at: findAndRemoveItems(name: name) )
                
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
