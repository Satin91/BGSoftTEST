//
//  ItemSpacingEnum.swift
//  BGSoftTEST
//
//  Created by Артур on 1.12.21.
//

import UIKit



//MARK:  Фиксированная величина отступов

enum ItemSpacing {
        
    enum iPad: CGFloat {
        case portrait  = 120
        case landscape = 200
        case compact   = 40
    }
    
    enum iPhone: CGFloat {
        case portrait = 50
        case landscape = 90
    }
    
    
}
