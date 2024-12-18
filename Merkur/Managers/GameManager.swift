//
//  GameManager.swift
//  Merkur
//
//  Created by Alex on 18.12.2024.
//

import Foundation
import Combine

@MainActor
final class GameManager: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var gameState = GameState()
    @Published private(set) var abilities: [Ability] = []
    @Published private(set) var isShieldActive = false
    
    // MARK: - Private Properties
    private var gameTimer: Timer.TimerPublisher?
    private var penaltyTimer: Timer.TimerPublisher?
    private var itemSpawnTimer: Timer.TimerPublisher?
    private var shieldTimer: Timer?
    private var spawnedItemsCount = 0
    private let shieldDuration: TimeInterval = 5.0
    private var cancellables = Set<AnyCancellable>()
    
    private let storageManager = StorageManager.shared
    let screenBounds: CGRect
    
    // Game configuration for current round
    private var currentSpeed: Double {
        Constants.Game.Rounds.baseItemSpeed *
        Constants.Game.Rounds.itemSpeedMultiplier[gameState.currentRound - 1]
    }
    
    private var currentMeteorCount: Int {
        Int(Double(Constants.Game.Rounds.baseMeteorCount) *
            Constants.Game.Rounds.meteorCountMultiplier[gameState.currentRound - 1])
    }
    
    // MARK: - Initialization
    init(screenBounds: CGRect) {
        self.screenBounds = screenBounds
        setupAbilities()
    }
    
    // MARK: - Game Control
    func startGame() {
        guard gameState.status == .notStarted else { return }
        
        resetGameState()
        startGameTimer()
        startItemSpawning()
        gameState.status = .playing
    }
    
    func pauseGame() {
        guard gameState.status == .playing else { return }
        
        cancelTimers()
        gameState.status = .paused
    }
    
    func resumeGame() {
        guard gameState.status == .paused else { return }
        
        startGameTimer()
        startItemSpawning()
        gameState.status = .playing
    }
    
    func endGame() {
        cancelTimers()
        
        // Save earned coins only if game completed successfully
        if case .completed(.victory) = gameState.status {
            storageManager.addCoins(gameState.coins)
            storageManager.saveHighestCompletedRound(gameState.currentRound)
        }
    }
    
    func updateRound(_ newRound: Int) {
        updateGameState { state in
            state.currentRound = newRound
        }
    }
    
    // MARK: - Item Interaction
    func handleItemTap(_ item: GameItem) {
        guard gameState.status == .playing && !gameState.isPenalized else { return }
        guard var tappedItem = gameState.activeItems.first(where: { $0.id == item.id }),
              tappedItem.isActive else { return }
        
        switch item.type {
        case .redMeteor, .blueMeteor:
            tappedItem.isActive = false
            updateGameState { state in
                if let index = state.activeItems.firstIndex(where: { $0.id == item.id }) {
                    state.activeItems[index] = tappedItem
                }
            }
            
        case .coin:
            tappedItem.isActive = false
            updateGameState { state in
                state.coins += 1
                if let index = state.activeItems.firstIndex(where: { $0.id == item.id }) {
                    state.activeItems[index] = tappedItem
                }
            }
            
        case .rocket:
            applyPenalty()
        }
    }
    
    // MARK: - Ability Usage
    func useAbility(_ type: AbilityType) {
        guard gameState.status == .playing,
              let index = abilities.firstIndex(where: { $0.type == type && $0.count > 0 && !$0.isActive })
        else { return }
        
        switch type {
        case .shield:
            activateShield()
        case .meteorDestruction:
            destroyAllMeteors()
        case .penaltyCancel:
            cancelPenalty()
        }
        
        // Update ability state
        var updatedAbility = abilities[index]
        updatedAbility.count -= 1
        updatedAbility.isActive = true
        abilities[index] = updatedAbility
        
        // Save updated abilities
        let abilityCounts = Dictionary(uniqueKeysWithValues:
            abilities.map { ($0.type, $0.count) }
        )
        storageManager.saveAbilities(abilityCounts)
    }
    
    // MARK: - Private Methods
    private func setupAbilities() {
        let savedAbilities = storageManager.getAbilities()
        abilities = AbilityType.allCases.map { type in
            Ability(type: type, count: savedAbilities[type] ?? 0, isActive: false)
        }
    }
    
    private func resetGameState() {
        updateGameState { state in
            state.health = Constants.Game.initialHealth
            state.coins = 0
            state.timeRemaining = Constants.Game.gameTime
            state.isPenalized = false
            state.penaltyTimeRemaining = 0
            state.activeItems = []
            // Reset ability active states
            abilities = abilities.map { ability in
                var updated = ability
                updated.isActive = false
                return updated
            }
        }
    }
    
    private func startGameTimer() {
        gameTimer = Timer.publish(every: 0.1, on: .main, in: .common)
        gameTimer?.autoconnect()
            .sink { [weak self] _ in
                self?.updateGameTime()
            }
            .store(in: &cancellables)
    }
    
    private func startItemSpawning() {
        itemSpawnTimer = Timer.publish(every: 1.0, on: .main, in: .common)
        itemSpawnTimer?.autoconnect()
            .sink { [weak self] _ in
                self?.spawnNewItems()
            }
            .store(in: &cancellables)
    }
    
    private func updateGameTime() {
        updateGameState { state in
            state.timeRemaining -= 0.1
            
            if state.timeRemaining <= 0 {
                state.status = .completed(.victory)
                endGame()
            }
        }
    }
    
    private func spawnNewItems() {
        let newItems = generateNewItems()
        updateGameState { state in
            state.activeItems.append(contentsOf: newItems)
        }
    }
    
    private func generateNewItems() -> [GameItem] {
        guard gameState.status == .playing else { return [] }
        
        let totalItemsNeeded = currentMeteorCount + Int(Double(currentMeteorCount) * 0.5) // Дополнительные монеты и ракеты
        guard spawnedItemsCount < totalItemsNeeded else { return [] }
        
        let availableWidth = screenBounds.width - 40 // Отступы по краям
        let numberOfItems = min(3, totalItemsNeeded - spawnedItemsCount) // Спавним по 2-3 предмета за раз
        
        var newItems: [GameItem] = []
        
        for _ in 0..<numberOfItems {
            let randomX = CGFloat.random(in: 20...(availableWidth - 20))
            let itemType = generateRandomItemType()
            
            let item = GameItem(
                type: itemType,
                position: CGPoint(x: randomX, y: -50) // Начальная позиция над экраном
            )
            
            newItems.append(item)
            spawnedItemsCount += 1
        }
        
        return newItems
    }
    
    private func generateRandomItemType() -> GameItemType {
        let random = Int.random(in: 1...100)
        
        switch random {
        case 1...50: // 50% шанс метеорита
            return Bool.random() ? .redMeteor : .blueMeteor
        case 51...80: // 30% шанс монеты
            return .coin
        default: // 20% шанс ракеты
            return .rocket
        }
    }
    
    private func applyPenalty() {
        guard !gameState.isPenalized else { return }
        
        updateGameState { state in
            state.isPenalized = true
            state.penaltyTimeRemaining = Constants.Game.penaltyTime
        }
        
        startPenaltyTimer()
    }
    
    private func startPenaltyTimer() {
        penaltyTimer = Timer.publish(every: 0.1, on: .main, in: .common)
        penaltyTimer?.autoconnect()
            .sink { [weak self] _ in
                self?.updatePenaltyTime()
            }
            .store(in: &cancellables)
    }
    
    private func updatePenaltyTime() {
        updateGameState { state in
            state.penaltyTimeRemaining -= 0.1
            
            if state.penaltyTimeRemaining <= 0 {
                state.isPenalized = false
                penaltyTimer = nil
            }
        }
    }
    
    private func cancelTimers() {
        cancellables.removeAll()
    }
    
    private func updateGameState(_ update: (inout GameState) -> Void) {
        update(&gameState)
    }
    
    // MARK: - Ability Effects
    private func checkItemDamage() {
        let damageItems = gameState.activeItems.filter {
            $0.shouldDamageHealth && $0.position.y >= screenBounds.height - 50
        }
        
        guard !damageItems.isEmpty else { return }
        
        updateGameState { state in
            // Если щит не активен, наносим урон
            if !isShieldActive {
                let damage = Double(damageItems.count) * Constants.Game.meteorDamage
                state.health -= damage
                
                // Проверяем окончание игры
                if state.health <= 0 {
                    state.health = 0
                    state.status = .completed(.defeat)
                    endGame()
                }
            }
            
            // Удаляем предметы, достигшие нижней границы
            state.activeItems.removeAll(where: { item in
                damageItems.contains(where: { $0.id == item.id })
            })
        }
    }
    
    private func activateShield() {
        isShieldActive = true
        
        // Отменяем существующий таймер щита, если он есть
        shieldTimer?.invalidate()
        
        // Запускаем новый таймер
        shieldTimer = Timer.scheduledTimer(withTimeInterval: shieldDuration, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.isShieldActive = false
                self?.shieldTimer = nil
                
                // Обновляем состояние способности
                if let index = self?.abilities.firstIndex(where: { $0.type == .shield }) {
                    self?.abilities[index].isActive = false
                }
            }
        }
    }
    
    private func destroyAllMeteors() {
        updateGameState { state in
            state.activeItems = state.activeItems.map { item in
                var updatedItem = item
                if item.type.isMeteor {
                    updatedItem.isActive = false
                }
                return updatedItem
            }
        }
    }
    
    private func cancelPenalty() {
        updateGameState { state in
            state.isPenalized = false
            state.penaltyTimeRemaining = 0
        }
        penaltyTimer = nil
    }
}
