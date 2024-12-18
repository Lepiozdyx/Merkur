//
//  GameViewModel.swift
//  Merkur
//
//  Created by Alex on 18.12.2024.
//

import SwiftUI
import Combine

@MainActor
final class GameViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var gameManager: GameManager
    @Published var showGameOverAlert = false
    @Published var showVictoryAlert = false
    @Published var showPauseAlert = false
    @Published private(set) var currentAchievement: Achievement?
    
    // MARK: - Public Properties
    var healthPercentage: Double {
        max(0, min(100, (gameManager.gameState.health / Constants.Game.initialHealth) * 100))
    }
    
    var formattedTime: String {
        String(format: "%.1f", max(0, gameManager.gameState.timeRemaining))
    }
    
    var isPenalized: Bool {
        gameManager.gameState.isPenalized
    }
    
    var currentRound: Int {
        gameManager.gameState.currentRound
    }
    
    var coins: Int {
        gameManager.gameState.coins
    }
    
    var isShieldActive: Bool {
        gameManager.isShieldActive
    }
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(screenBounds: CGRect) {
        self.gameManager = GameManager(screenBounds: screenBounds)
        setupGameStateObserver()
    }
    
    // MARK: - Public Methods
    func startGame() {
        gameManager.startGame()
    }
    
    func pauseGame() {
        gameManager.pauseGame()
        showPauseAlert = true
    }
    
    func resumeGame() {
        showPauseAlert = false
        gameManager.resumeGame()
    }
    
    func exitToMenu() {
        gameManager.endGame()
    }
    
    func handleItemTap(_ item: GameItem) {
        gameManager.handleItemTap(item)
    }
    
    func useAbility(_ type: AbilityType) {
        gameManager.useAbility(type)
    }
    
    // MARK: - Private Methods
    private func setupGameStateObserver() {
        gameManager.$gameState
            .sink { [weak self] state in
                self?.handleGameStateChange(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleGameStateChange(_ state: GameState) {
        switch state.status {
        case .completed(.victory):
            generateRandomAchievement()
            showVictoryAlert = true
        case .completed(.defeat):
            showGameOverAlert = true
        default:
            break
        }
    }
    
    private func generateRandomAchievement() {
        let randomType = AchievementType.allCases.randomElement()!
        currentAchievement = Achievement(type: randomType, isUnlocked: true)
    }
    
    // MARK: - Alert Actions
    func handleNextRound() {
        guard currentRound < Constants.Game.Rounds.maxRounds else {
            exitToMenu()
            return
        }
        
        gameManager = GameManager(screenBounds: gameManager.screenBounds)
        gameManager.updateRound(currentRound + 1)
        showVictoryAlert = false
        startGame()
    }
    
    func handleTryAgain() {
        gameManager = GameManager(screenBounds: gameManager.screenBounds)
        showGameOverAlert = false
        startGame()
    }
}
