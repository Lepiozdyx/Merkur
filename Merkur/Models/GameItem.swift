//
//  GameItem.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import Foundation

enum GameItemType {
    case redMeteor
    case blueMeteor
    case coin
    case rocket
    
    var image: String {
        switch self {
        case .redMeteor: return "redMeteor"
        case .blueMeteor: return "blueMeteor"
        case .coin: return "coin"
        case .rocket: return "rocket"
        }
    }
    
    var isMeteor: Bool {
        switch self {
        case .redMeteor, .blueMeteor: return true
        default: return false
        }
    }
}

struct GameItem: Identifiable {
    let id = UUID()
    let type: GameItemType
    var position: CGPoint
    var isActive: Bool = true
    
    var shouldDamageHealth: Bool {
        isActive && type.isMeteor
    }
}
