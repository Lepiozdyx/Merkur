//
//  ItemView.swift
//  Merkur
//
//  Created by Alex on 19.12.2024.
//

import SwiftUI

struct ItemView: View {
    let item: GameItem
    let screenHeight: CGFloat
    let currentRound: Int
    let onTap: () -> Void
    let onFall: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var hasFallen = false
    
    var body: some View {
        Image(item.type.image)
            .resizable()
            .frame(width: Constants.Screen.itemSize, height: Constants.Screen.itemSize * 1.1)
            .position(x: item.position.x, y: item.position.y + offset)
            .opacity(item.isEnabled ? 1 : 0)
            .onTapGesture {
                guard item.isEnabled else { return }
                playItemSound()
                onTap()
            }
            .onAppear {
                let fallingDuration = Constants.Rounds.getFallingDuration(for: currentRound)
                
                withAnimation(.linear(duration: fallingDuration)) {
                    offset = screenHeight + Constants.Screen.itemSize * 2
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + fallingDuration) {
                    if !hasFallen && item.isEnabled {
                        hasFallen = true
                        onFall()
                    }
                }
            }
    }
    
    private func playItemSound() {
        switch item.type {
        case .redMeteor, .blueMeteor:
            SoundManager.shared.playSound(.meteor)
        case .coin:
            SoundManager.shared.playSound(.coin)
        case .rocket:
            SoundManager.shared.playSound(.rocket)
        }
    }
}
