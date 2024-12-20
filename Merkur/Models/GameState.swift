//
//  GameState.swift
//  Merkur
//
//  Created by Alex on 19.12.2024.
//

import Foundation

enum GameState {
    case initial
    case countdown(Int)
    case playing
    case paused
    case gameOver(score: Int)
    case victory(score: Int)
}
