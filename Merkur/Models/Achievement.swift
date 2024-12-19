//
//  Achievement.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import Foundation

enum AchievementType {
    case solarWarrior
    case planetProtector
    case auroraGlow
    case eclipseMastery
    case lightOfLife
    case cosmicBlaze
    case starSovereign
    case eternalRadiance
    case balanceKeeper
    case flashOfHope
    case fieryTrail
    case dayCreator
    case lunarShadow
    case solarFlare
    case goldenHeart
    
    var image: ImageResource {
        switch self {
        case .solarWarrior: return .solarWarrior
        case .planetProtector: return .planetProtector
        case .auroraGlow: return .auroraGlow
        case .eclipseMastery: return .eclipseMastery
        case .lightOfLife: return .lightOfLife
        case .cosmicBlaze: return .cosmicBlaze
        case .starSovereign: return .starSovereign
        case .eternalRadiance: return .eternalRadiance
        case .balanceKeeper: return .balanceKeeper
        case .flashOfHope: return .flashOfHope
        case .fieryTrail: return .fieryTrail
        case .dayCreator: return .dayCreator
        case .lunarShadow: return .lunarShadow
        case .solarFlare: return .solarFlare
        case .goldenHeart: return .goldenHeart
        }
    }
    
    static var random: AchievementType {
        let all: [AchievementType] = [
            .solarWarrior, .planetProtector, .auroraGlow,
            .eclipseMastery, .lightOfLife, .cosmicBlaze,
            .starSovereign, .eternalRadiance, .balanceKeeper,
            .flashOfHope, .fieryTrail, .dayCreator,
            .lunarShadow, .solarFlare, .goldenHeart
        ]
        return all.randomElement() ?? .solarWarrior
    }
}

struct Achievement: Identifiable {
    let id = UUID()
    let type: AchievementType
    var isUnlocked: Bool = false
}
