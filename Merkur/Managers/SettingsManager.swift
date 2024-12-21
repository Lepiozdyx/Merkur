//
//  SettingsManager.swift
//  Merkur
//
//  Created by Alex on 21.12.2024.
//

import Foundation

final class SettingsManager {
    private enum Keys: String {
        case isSoundEnabled
        case isMusicEnabled
    }
    
    static let shared = SettingsManager()
    
    var isSoundEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.isSoundEnabled.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.isSoundEnabled.rawValue) }
    }
    
    var isMusicEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.isMusicEnabled.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.isMusicEnabled.rawValue) }
    }
    
    private init() {
        if UserDefaults.standard.object(forKey: Keys.isSoundEnabled.rawValue) == nil {
            isSoundEnabled = true
        }
        if UserDefaults.standard.object(forKey: Keys.isMusicEnabled.rawValue) == nil {
            isMusicEnabled = true
        }
    }
}
