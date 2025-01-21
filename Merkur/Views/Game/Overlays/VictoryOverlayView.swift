//
//  VictoryOverlayView.swift
//  Merkur
//
//  Created by Alex on 18.12.2024.
//

import SwiftUI

struct VictoryOverlayView: View {
    let coins: Int
    let round: Int
    let achievement: Achievement?
    let onNextRound: () -> Void
    let onExit: () -> Void
    
    @State private var isAnimating = false
    
    var body: some View {
        Color.green.opacity(0.5)
            .ignoresSafeArea()
            .overlay {
                ZStack {
                    Image(.menuUnderlay)
                        .resizable()
                        .frame(maxWidth: 400, maxHeight: 350)
                        .overlay(alignment: .top) {
                            Text("VICTORY!")
                                .mFont(18)
                                .offset(y: 35)
                        }
                        .overlay(alignment: .topTrailing) {
                            if let achievement = achievement {
                                Image(achievement.type.image)
                                    .resizable()
                                    .frame(width: 160, height: 120)
                                    .shadow(color: .yellow, radius: isAnimating ? 14 : 8)
                                    .scaleEffect(isAnimating ? 1 : 0.98)
                                    .animation(
                                        .easeInOut(duration: 0.7)
                                        .repeatForever(autoreverses: true),
                                        value: isAnimating
                                    )
                                    .offset(x: 20, y: -15)
                                    .onAppear {
                                        isAnimating.toggle()
                                    }
                            }
                        }
                    
                    VStack(spacing: 10) {
                        VStack(spacing: 4) {
                            Text("WAVE \(round)")
                                .mFont(18)
                            
                            HStack {
                                Text("SCORE:")
                                    .mFont(18)
                                
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
                            onNextRound()
                        } label: {
                            ActionView(
                                text: "NEXT ROUND",
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
    VictoryOverlayView(coins: 100, round: 2, achievement: .init(type: AchievementType.auroraGlow), onNextRound: {}, onExit: {})
}
