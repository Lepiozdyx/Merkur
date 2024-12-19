//
//  GameOverOverlayView.swift
//  Merkur
//
//  Created by Alex on 18.12.2024.
//

import SwiftUI

struct GameOverOverlayView: View {
    let coins: Int
    let round: Int
    let onRetry: () -> Void
    let onExit: () -> Void
    
    var body: some View {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
            .overlay {
                ZStack {
                    Image(.menuUnderlay)
                        .resizable()
                        .frame(maxWidth: 400, maxHeight: 350)
                        .overlay(alignment: .top) {
                            Text("GAME OVER!")
                                .mFont(16)
                                .padding(.top, 5)
                        }
                    
                    VStack(spacing: 10) {
                        VStack(spacing: 4) {
                            Text("WAVE \(round)")
                                .mFont(18)
                            
                            HStack {
                                Text("SCORE:")
                                    .mFont(20)
                                
                                HStack {
                                    Text("+\(coins)")
                                        .mFont(20)
                                    Image(.coin)
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }
                            }
                        }
                        
                        Button {
                            onRetry()
                        } label: {
                            ActionView(
                                text: "RETRY",
                                fontSize: 28,
                                width: 250,
                                height: 70
                            )
                        }
                        
                        Button {
                            onExit()
                        } label: {
                            ActionView(
                                text: "MENU",
                                fontSize: 28,
                                width: 250,
                                height: 70
                            )
                        }
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
    }
}

#Preview {
    GameOverOverlayView(coins: 100, round: 1, onRetry: {}, onExit: {})
}
