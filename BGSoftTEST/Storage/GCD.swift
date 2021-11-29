//
//  GCD.swift
//  BGSoftTEST
//
//  Created by Артур on 29.11.21.
//

import Foundation

class Queue {
    
    private static let labelIdentifier: String = "PhotoLoading"
    
    // MARK: Очередь для загрузки всех фото
    
    static func PhotoLoading(_ priority: DispatchQoS ,complition: @escaping @convention(block) () -> Void) {
        DispatchQueue(label: labelIdentifier,qos: priority,attributes: [.concurrent]).sync(execute: complition)
    }
    
    // MARK: Очередь для назначения фото в ячейку
    
    static func AssignPhotoToCell(_ priority: DispatchQoS ,complition: @escaping @convention(block) () -> Void) {
        DispatchQueue(label: labelIdentifier,qos: priority,attributes: [.concurrent]).async(execute: complition)
    }
}
