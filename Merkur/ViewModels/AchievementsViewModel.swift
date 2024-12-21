//
//  AchievementsViewModel.swift
//  Merkur
//
//  Created by Alex on 21.12.2024.
//

import Foundation
import Combine

@MainActor
final class AchievementsViewModel: ObservableObject {
    @Published private(set) var achievements: [Achievement] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupAchievements()
        subscribeToUserData()
    }
    
    private func setupAchievements() {
        achievements = [
            .init(type: .solarWarrior),
            .init(type: .planetProtector),
            .init(type: .auroraGlow),
            .init(type: .eclipseMastery),
            .init(type: .lightOfLife),
            .init(type: .cosmicBlaze),
            .init(type: .starSovereign),
            .init(type: .eternalRadiance),
            .init(type: .balanceKeeper),
            .init(type: .flashOfHope),
            .init(type: .fieryTrail),
            .init(type: .dayCreator),
            .init(type: .lunarShadow),
            .init(type: .solarFlare),
            .init(type: .goldenHeart)
        ]
    }
    
    private func subscribeToUserData() {
        AppStateService.shared.userDataPublisher
            .sink { [weak self] userData in
                self?.updateAchievements(with: userData.unlockedAchievements)
            }
            .store(in: &cancellables)
    }
    
    private func updateAchievements(with unlockedTypes: Set<String>) {
        achievements = achievements.map { achievement in
            var updated = achievement
            updated.isUnlocked = unlockedTypes.contains(String(describing: achievement.type))
            return updated
        }
    }
}
