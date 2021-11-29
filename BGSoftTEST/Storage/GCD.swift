//
//  GCD.swift
//  BGSoftTEST
//
//  Created by Артур on 29.11.21.
//

import Foundation

class Queue {
    
    let labelIdentifier: String = "PhotoLoading"
    
    // MARK: Очередь для загрузки всех фото
    
     func PhotoLoading(_ priority: DispatchQoS ,complition: @escaping @convention(block) () -> Void) {
         DispatchQueue(label: labelIdentifier,qos: priority,attributes: .concurrent).async(execute: complition)
    }
    
    // MARK: Очередь для назначения фото в ячейку
    
     func AssignPhotoToCell(_ priority: DispatchQoS ,complition: @escaping @convention(block) () -> Void) {
         DispatchQueue(label: labelIdentifier,qos: priority).sync(execute: complition)
    }
    let oper = OperationQueue()
    
}

