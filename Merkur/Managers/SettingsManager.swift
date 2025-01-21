//
//  SettingsManager.swift
//  Merkur
//
//  Created by Alex on 21.12.2024.
//

import Foundation

final class SettingsManager {
    private enum Keys: String {
        case sound
        case music
    }
    
    static let shared = SettingsManager()
    
    var isSoundEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.sound.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.sound.rawValue) }
    }
    
    var isMusicEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.music.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.music.rawValue) }
    }
    
    private init() {
        if UserDefaults.standard.object(forKey: Keys.sound.rawValue) == nil {
            isSoundEnabled = true
        }
        if UserDefaults.standard.object(forKey: Keys.music.rawValue) == nil {
            isMusicEnabled = true
        }
    }
}
