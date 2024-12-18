//
//  Achievement.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import Foundation

enum AchievementType: String, CaseIterable {
    case solarWarrior = "Solar Warrior"
    case planetProtector = "Planet Protector"
    case auroraGlow = "Aurora Glow"
    case eclipseMastery = "Eclipse Mastery"
    case lightOfLife = "Light of Life"
    case cosmicBlaze = "Cosmic Blaze"
    case starSovereign = "Star Sovereign"
    case eternalRadiance = "Eternal Radiance"
    case balanceKeeper = "Balance Keeper"
    case flashOfHope = "Flash of Hope"
    case fieryTrail = "Fiery Trail"
    case dayCreator = "Day Creator"
    case lunarShadow = "Lunar Shadow"
    case solarFlare = "Solar Flare"
    case goldenHeart = "Golden Heart"
    
    var image: String {
        rawValue.replacingOccurrences(of: " ", with: "")
    }
}

struct Achievement: Identifiable {
    let id = UUID()
    let type: AchievementType
    var isUnlocked: Bool = false
}
