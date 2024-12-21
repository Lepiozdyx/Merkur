//
//  AppStateService.swift
//  Merkur
//
//  Created by Alex on 19.12.2024.
//

import Foundation
import Combine

final class AppStateService {
    static let shared = AppStateService()
    
    private let storageManager: StorageManagerProtocol
    private let userDataSubject = CurrentValueSubject<UserData, Never>(.empty)
    
    var userDataPublisher: AnyPublisher<UserData, Never> {
        userDataSubject.eraseToAnyPublisher()
    }
    
    private init(storageManager: StorageManagerProtocol = StorageManager()) {
        self.storageManager = storageManager
        loadUserData()
    }
    
    // MARK: - Methods
    func loadUserData() {
        if let data = storageManager.getUserData() {
            userDataSubject.send(data)
        }
    }
    
    func updateUserData(_ userData: UserData) {
        storageManager.saveUserData(userData)
        userDataSubject.send(userData)
    }
    
    func addCoins(_ amount: Int) {
        var updatedUserData = userDataSubject.value
        updatedUserData.coins += amount
        updateUserData(updatedUserData)
    }
    
    func spendCoins(_ amount: Int) -> Bool {
        guard userDataSubject.value.coins >= amount else { return false }
        
        var updatedUserData = userDataSubject.value
        updatedUserData.coins -= amount
        updateUserData(updatedUserData)
        return true
    }
    
    // MARK: - Abilities Methods
    func updateAbilities(_ abilities: PurchasedAbilities) {
        var updatedUserData = userDataSubject.value
        updatedUserData.purchasedAbilities = abilities
        updateUserData(updatedUserData)
    }
    
    @discardableResult
    func purchaseAbility(_ type: AbilityType) -> Bool {
        guard spendCoins(type.price) else { return false }
        
        var updatedUserData = userDataSubject.value
        updatedUserData.purchasedAbilities.addAbility(type)
        updateUserData(updatedUserData)
        return true
    }
    
    @discardableResult
    func useAbility(_ type: AbilityType) -> Bool {
        var updatedUserData = userDataSubject.value
        guard updatedUserData.purchasedAbilities.getCount(for: type) > 0 else { return false }
        
        updatedUserData.purchasedAbilities.useAbility(type)
        updateUserData(updatedUserData)
        return true
    }
    
    // MARK: - Achievements Methods
    func unlockAchievement(_ type: AchievementType) {
        var updatedUserData = userDataSubject.value
        updatedUserData.unlockedAchievements.insert(String(describing: type))
        updateUserData(updatedUserData)
    }
}
