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
    let isTimeShiftActive: Bool
    let onTap: () -> Void
    let onFall: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var hasFallen = false
    @State private var showExplosion = false
    @State private var explosionOpacity = 0.0
    @State private var itemOpacity = 1.0
    
    var body: some View {
        ZStack {
            // Item
            Image(item.type.image)
                .resizable()
                .frame(width: Constants.Screen.itemSize, height: Constants.Screen.itemSize * 1.1)
                .opacity(item.isEnabled ? itemOpacity : 0)
                .onTapGesture {
                    guard item.isEnabled else { return }
                    handleTap()
                }
            
            // Explosion effect
            Image(.boom)
                .resizable()
                .frame(width: Constants.Screen.itemSize * 1.2, height: Constants.Screen.itemSize * 1.2)
                .opacity(explosionOpacity)
        }
        .position(x: item.position.x, y: item.position.y + offset)
        .onAppear {
            startFallingAnimation()
        }
    }
    
    private func handleTap() {
        playItemSound()
        
        showExplosion = true
        withAnimation(.easeIn(duration: 0.1)) {
            explosionOpacity = 1.0
            itemOpacity = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeOut(duration: 0.2)) {
                explosionOpacity = 0.0
            }
        }
        
        onTap()
    }
    
    private func startFallingAnimation() {
        let fallingDuration = Constants.Rounds.getFallingDuration(
            for: currentRound,
            withTimeShift: isTimeShiftActive
        )
        
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
