//
//  UserData.swift
//  Merkur
//
//  Created by Alex on 19.12.2024.
//

import Foundation

struct UserData: Codable {
    var coins: Int
    var wave: Int
    
    static let empty = UserData(coins: 0, wave: 0)
}
