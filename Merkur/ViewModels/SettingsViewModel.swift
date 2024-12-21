//
//  SettingsViewModel.swift
//  Merkur
//
//  Created by Alex on 21.12.2024.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var isSoundEnabled: Bool {
        didSet {
            SettingsManager.shared.isSoundEnabled = isSoundEnabled
            if isSoundEnabled {
                SoundManager.shared.playSound(.click)
            }
        }
    }
    
    @Published var isMusicEnabled: Bool {
        didSet {
            SettingsManager.shared.isMusicEnabled = isMusicEnabled
            SoundManager.shared.updateMusicState()
            if isSoundEnabled {
                SoundManager.shared.playSound(.click)
            }
        }
    }
    
    init() {
        self.isSoundEnabled = SettingsManager.shared.isSoundEnabled
        self.isMusicEnabled = SettingsManager.shared.isMusicEnabled
    }
    
    func toggleSound() {
        isSoundEnabled.toggle()
    }
    
    func toggleMusic() {
        isMusicEnabled.toggle()
    }
}
