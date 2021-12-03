//
//  SendFirstIndexProtocol.swift
//  BGSoftTEST
//
//  Created by Артур on 3.12.21.
//

import UIKit

// Протокол, который отправляет первый индекс из группы

protocol CompositionalFirstIndex {
    func sendValueOf(firstIndexPath: IndexPath)
}
