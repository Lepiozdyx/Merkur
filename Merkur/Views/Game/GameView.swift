//
//  GameView.swift
//  Merkur
//
//  Created by Alex on 18.12.2024.
//

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                MainBGView(isGamefield: true)
                
                // Menu Button
                VStack {
                    HStack {
                        MenuButtonView {
                            if case .playing = vm.gameState {
                                vm.pauseGame()
                            } else {
                                dismiss()
                            }
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
                
                // Health bar
                VStack {
                    HStack {
                        Spacer()
                        HealthBarView(
                            width: 185,
                            height: 50,
                            healthBarWidth: 125,
                            currentHealth: vm.health
                        )
                    }
                    Spacer()
                }
                .padding()
                
                // Ability buttons
                
                // Game States
                switch vm.gameState {
                case .initial:
                    StartButtonView { vm.startGame() }
                case .countdown(let count):
                    countdownView(count: count)
                case .playing:
                    gameView(in: geometry)
                case .paused:
                    gameView(in: geometry)
                        .overlay {
                            PauseOverlayView {
                                vm.resumeGame()
                            } onExit: {
                                vm.resetGame()
                                dismiss()
                            }
                        }
                case .gameOver(let score, let round):
                    gameView(in: geometry)
                        .overlay {
                            GameOverOverlayView(
                                coins: score,
                                round: round,
                                onRetry: {
                                    vm.retryGame()
                                },
                                onExit: {
                                    vm.resetGame()
                                    dismiss()
                                }
                            )
                        }
                case .victory(let score, let round):
                    EmptyView()
                }
            }
            .onAppear {
                vm.updateLayout(
                    size: geometry.size,
                    safeArea: geometry.safeAreaInsets
                )
            }
            .onChange(of: geometry.size) { newSize in
                vm.updateLayout(
                    size: newSize,
                    safeArea: geometry.safeAreaInsets
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func countdownView(count: Int) -> some View {
        Text("\(count)")
            .mFont(50)
            .transition(.scale)
    }
    
    private func gameView(in geometry: GeometryProxy) -> some View {
        ZStack {
            // Timer
            VStack {
                HStack {
                    Spacer()
                    ActionView(
                        text: String(format: "%.0f", vm.timeRemaining),
                        fontSize: 30,
                        width: 100,
                        height: 44
                    )
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.top)
            
            // Falling items
            ForEach(vm.items) { item in
                ItemView(
                    item: item,
                    screenHeight: geometry.size.height,
                    onTap: {
                        vm.tapItem(item)
                    },
                    onFall: {
                        vm.handleItemFall(item)
                    }
                )
            }
            
            // Penalty Overlay
            if vm.isPenalty {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .allowsHitTesting(false)
                
                PenaltyOverlayView()
                    .transition(.scale)
                    .allowsHitTesting(false)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    GameView()
}
