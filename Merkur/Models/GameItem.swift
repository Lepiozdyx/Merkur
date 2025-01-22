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
    
    var image: ImageResource {
        switch self {
        case .redMeteor: return .redMeteor
        case .blueMeteor: return .blueMeteor
        case .coin: return .coin
        case .rocket: return .rocket
        }
    }
    
    var isMeteor: Bool {
        switch self {
        case .redMeteor, .blueMeteor: return true
        default: return false
        }
    }
    
    var isCoin: Bool {
        self == .coin
    }
    
    var isRocket: Bool {
        self == .rocket
    }
    
    var damage: Double {
        switch self {
        case .redMeteor, .blueMeteor:
            return Constants.Play.meteorDamage
        case .rocket:
            return Constants.Play.rocketDamage
        default:
            return 0
        }
    }
    
    var shouldDamageHealth: Bool {
        isMeteor || isRocket
    }
    
    static var randomItem: GameItemType {
        let types: [GameItemType] = [.rocket, .redMeteor, .blueMeteor]
        return types.randomElement() ?? .redMeteor
    }
}

struct GameItem: Identifiable {
    let id = UUID()
    let type: GameItemType
    var position: CGPoint
    var isEnabled: Bool = true
    
    var shouldDamageHealth: Bool {
        isEnabled && type.shouldDamageHealth
    }
}
