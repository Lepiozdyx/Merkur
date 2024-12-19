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
        isPenalty = false
        penaltyTimer?.cancel()
        itemGenerationTimer?.cancel()
    }
    
    func tapItem(_ item: GameItem) {
        guard case .playing = gameState,
              !isPenalty,
              item.isEnabled else { return }
        
        if item.type.isCoin {
            score += 1
            updateUserData()
        } else if item.type.isMeteor {
            // ???
        } else {
            activatePenalty()
        }
        
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isEnabled = false
        }
    }
    
    // MARK: - Private Methods
    private func setupSubscriptions() {
        gameStateManager.gameState
            .sink { [weak self] state in
                self?.gameState = state
                if case .playing = state {
                    self?.startGeneratingItems()
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
        itemGenerationTimer = Timer.publish(
            every: Constants.Play.itemGenerationPeriod,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            self?.generateNewItem()
        }
    }
    
    private func generateNewItem() {
        guard items.count < Constants.Play.maxFallingItems else { return }
        
        // % chance of coins dropping
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
    
    private func updateUserData() {
        AppStateService.shared.addCoins(1)
    }
}
