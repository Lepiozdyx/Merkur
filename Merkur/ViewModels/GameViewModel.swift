//
//  GameViewModel.swift
//  Merkur
//
//  Created by Alex on 19.12.2024.
//

import SwiftUI
import Combine

@MainActor
final class GameViewModel: ObservableObject {
    @Published private(set) var items: [GameItem] = []
    @Published private(set) var gameState: GameState = .initial
    @Published private(set) var timeRemaining: TimeInterval = Constants.Play.gamePlayDuration
    @Published private(set) var isPenalty = false
    @Published private(set) var score = 0
    @Published private(set) var health: Double = Constants.Play.initialHealth
    @Published private(set) var currentRound = 1
    @Published private(set) var currentAchievement: Achievement?
    
    private let gameStateManager: GameStateManagerProtocol
    private var penaltyTimer: AnyCancellable?
    private var itemGenerationTimer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Layout Properties
    private var screenSize: CGSize = .zero
    private var safeAreaInsets: EdgeInsets = .init()
    
    private var minX: CGFloat {
        safeAreaInsets.leading + Constants.Screen.itemSize/2
    }
    
    private var maxX: CGFloat {
        screenSize.width - safeAreaInsets.trailing - Constants.Screen.itemSize/2
    }
    
    // MARK: - Init
    init(gameStateManager: GameStateManagerProtocol = GameStateManager()) {
        self.gameStateManager = gameStateManager
        setupSubscriptions()
    }
    
    // MARK: - Public Methods
    func updateLayout(size: CGSize, safeArea: EdgeInsets) {
        screenSize = size
        safeAreaInsets = safeArea
    }
    
    func startGame() {
        gameStateManager.startGame()
    }
    
    func resetGame() {
        gameStateManager.resetGame()
        items.removeAll()
        score = 0
        health = Constants.Play.initialHealth
        isPenalty = false
        penaltyTimer?.cancel()
        itemGenerationTimer?.cancel()
    }
    
    func pauseGame() {
        guard case .playing = gameState else { return }
        gameStateManager.pauseGame()
        itemGenerationTimer?.cancel()
    }
    
    func resumeGame() {
        gameStateManager.resumeGame()
        startGeneratingItems()
    }
    
    func retryGame() {
        resetGame()
        startGame()
    }
    
    func startNextRound() {
        guard currentRound < Constants.Rounds.maxRoundsNumber else { return }
        currentRound += 1
        resetGame()
        startGame()
    }
    
    func updateHighestWave() {
        var cancellable: AnyCancellable?
        cancellable = AppStateService.shared.userDataPublisher
            .first()
            .sink { [weak self] userData in
                guard let self = self else { return }
                if self.currentRound > userData.wave {
                    AppStateService.shared.updateUserData(UserData(
                        coins: userData.coins,
                        wave: self.currentRound
                    ))
                }
                cancellable?.cancel()
            }
    }
    
    func tapItem(_ item: GameItem) {
        guard case .playing = gameState,
              !isPenalty,
              item.isEnabled else { return }
        
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            var updatedItem = items[index]
            
            if item.type.isCoin {
                score += 1
                updateUserData()
                updatedItem.isEnabled = false
            } else if item.type.isMeteor {
                updatedItem.isEnabled = false
            } else if item.type == .rocket {
                activatePenalty()
            }
            
            items[index] = updatedItem
        }
    }
    
    func handleItemFall(_ item: GameItem) {
        guard case .playing = gameState else { return }
        
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            if items[index].isEnabled {
                if item.shouldDamageHealth {
                    applyDamage()
                }
                items[index].isEnabled = false
            }
        }
    }
    
    // MARK: - Private Methods
    private func setupSubscriptions() {
        gameStateManager.gameState
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .victory:
                    self.stopGame()
                    self.currentAchievement = Achievement(type: .random)
                    self.gameState = state
                case .gameOver, .paused:
                    self.stopGame()
                    self.gameState = state
                case .playing:
                    self.startGeneratingItems()
                    self.gameState = state
                default:
                    self.gameState = state
                }
            }
            .store(in: &cancellables)
        
        gameStateManager.timer
            .sink { [weak self] time in
                self?.timeRemaining = Constants.Play.gamePlayDuration - time
            }
            .store(in: &cancellables)
    }
    
    private func startGeneratingItems() {
        itemGenerationTimer?.cancel()
        
        let generationPeriod = Constants.Rounds.getGenerationPeriod(for: currentRound)
        itemGenerationTimer = Timer.publish(
            every: generationPeriod,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            self?.generateNewItem()
        }
    }
    
    private func generateNewItem() {
        let maxItems = Constants.Rounds.getMaxFallingItems(for: currentRound)
        guard items.count < maxItems else { return }
        
        let itemType: GameItemType = Int.random(in: 1...Constants.Play.coinsDroppingChance) == 1
        ? .coin
        : GameItemType.randomItem
        
        let xPosition = CGFloat.random(in: minX...maxX)
        
        let item = GameItem(
            type: itemType,
            position: CGPoint(x: xPosition, y: -Constants.Screen.itemSize)
        )
        items.append(item)
    }
    
    private func activatePenalty() {
        isPenalty = true
        penaltyTimer = Timer.publish(every: Constants.Play.penaltyDuration, on: .main, in: .common)
            .autoconnect()
            .first()
            .sink { [weak self] _ in
                self?.isPenalty = false
            }
    }
    
    private func applyDamage() {
        health = max(0, health - Constants.Play.meteorDamage)
        
        if health <= 0 {
            stopGame()
            gameStateManager.endGame(withScore: score, isVictory: false)
        }
    }
    
    private func stopGame() {
        itemGenerationTimer?.cancel()
        penaltyTimer?.cancel()
        isPenalty = false
    }
    
    private func updateUserData() {
        AppStateService.shared.addCoins(1)
    }
}
