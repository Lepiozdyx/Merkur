//
//  GameStateManager.swift
//  Merkur
//
//  Created by Alex on 19.12.2024.
//

import Foundation
import Combine

protocol GameStateManagerProtocol {
    var gameState: CurrentValueSubject<GameState, Never> { get }
    var timer: CurrentValueSubject<TimeInterval, Never> { get }
    
    func startGame()
    func pauseGame()
    func resumeGame()
    func endGame(withScore score: Int, isVictory: Bool)
    func resetGame()
}

final class GameStateManager: GameStateManagerProtocol {
    let gameState = CurrentValueSubject<GameState, Never>(.initial)
    let timer = CurrentValueSubject<TimeInterval, Never>(0)
    
    private var timerCancellable: AnyCancellable?
    private var countdownCancellable: AnyCancellable?
    private var currentRound = 1
    
    func startGame() {
        resetGame()
        startCountdown()
    }
    
    func pauseGame() {
        timerCancellable?.cancel()
        gameState.send(.paused)
    }
    
    func resumeGame() {
        guard case .paused = gameState.value else { return }
        startGameTimer()
    }
    
    func endGame(withScore score: Int, isVictory: Bool) {
        timerCancellable?.cancel()
        if isVictory {
            gameState.send(.victory(score: score, round: currentRound))
        } else {
            gameState.send(.gameOver(score: score, round: currentRound))
        }
    }
    
    func resetGame() {
        timerCancellable?.cancel()
        countdownCancellable?.cancel()
        timer.send(0)
        gameState.send(.initial)
    }
    
    private func startCountdown() {
        var countdown = Constants.Play.countdownDuration
        gameState.send(.countdown(countdown))
        
        countdownCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                countdown -= 1
                if countdown > 0 {
                    self?.gameState.send(.countdown(countdown))
                } else {
                    self?.countdownCancellable?.cancel()
                    self?.startGameTimer()
                }
            }
    }
    
    private func startGameTimer() {
        gameState.send(.playing)
        
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                let newTime = self.timer.value + 0.1
                
                if newTime >= Constants.Play.gamePlayDuration {
                    self.endGame(withScore: 0, isVictory: true)
                } else {
                    self.timer.send(newTime)
                }
            }
    }
}
