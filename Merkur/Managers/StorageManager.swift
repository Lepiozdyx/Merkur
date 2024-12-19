//
//  StorageManager.swift
//  Merkur
//
//  Created by Alex on 18.12.2024.
//

import Foundation

protocol StorageManagerProtocol {
    func saveUserData(_ userData: UserData)
    func getUserData() -> UserData?
}

final class StorageManager: StorageManagerProtocol {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveUserData(_ userData: UserData) {
        if let data = try? JSONEncoder().encode(userData) {
            userDefaults.set(data, forKey: Constants.StorageKey.userData.rawValue)
        }
    }
    
    func getUserData() -> UserData? {
        guard let data = userDefaults.data(forKey: Constants.StorageKey.userData.rawValue) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode(UserData.self, from: data)
    }
}
