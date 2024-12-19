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
    
    func updateResources(coins: Int? = nil) {
        var updatedUserData = userDataSubject.value
        
        if let coins = coins {
            updatedUserData.coins = coins
        }
        
        storageManager.saveUserData(updatedUserData)
        userDataSubject.send(updatedUserData)
    }
    
    func addCoins(_ amount: Int) {
        let updatedUserData = UserData(
            coins: userDataSubject.value.coins + amount,
            wave: userDataSubject.value.wave
        )
        
        updateUserData(updatedUserData)
    }
    
    func spendCoins(_ amount: Int) -> Bool {
        guard userDataSubject.value.coins >= amount else { return false }
        
        let updatedUserData = UserData(
            coins: userDataSubject.value.coins - amount,
            wave: userDataSubject.value.wave
        )
        
        updateUserData(updatedUserData)
        return true
    }
}
