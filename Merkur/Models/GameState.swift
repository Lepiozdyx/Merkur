//
//  GameState.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import Foundation

enum GameStatus: Equatable {
    case notStarted
    case playing
    case paused
    case completed(Result)
    case gameOver
    
    enum Result {
        case victory
        case defeat
    }
}

struct GameState {
    var status: GameStatus = .notStarted
    var currentRound: Int = 1
    var health: Double = Constants.Game.initialHealth
    var coins: Int = 0
    var timeRemaining: Double = Constants.Game.gameTime
    var isPenalized: Bool = false
    var penaltyTimeRemaining: Double = 0
    var activeItems: [GameItem] = []
    var highestCompletedRound: Int = 0
}
