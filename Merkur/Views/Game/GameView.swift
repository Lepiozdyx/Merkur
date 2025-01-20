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
                
                // MARK: Menu Button
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
                
                // MARK: Health bar
                VStack {
                    HStack {
                        Spacer()
                        HealthBarView(
                            width: 150,
                            height: 35,
                            healthBarWidth: 104,
                            currentHealth: vm.health
                        )
                    }
                    Spacer()
                }
                .padding()
                
                // MARK: Game States
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
                case .gameOver(let score):
                    gameView(in: geometry)
                        .overlay {
                            GameOverOverlayView(
                                coins: score,
                                round: vm.currentRound,
                                onRetry: {
                                    vm.retryGame()
                                },
                                onExit: {
                                    vm.resetGame()
                                    dismiss()
                                }
                            )
                        }
                case .victory(let score):
                    gameView(in: geometry)
                        .overlay {
                            VictoryOverlayView(
                                coins: score,
                                round: vm.currentRound,
                                achievement: vm.currentAchievement,
                                onNextRound: {
                                    vm.updateHighestWave()
                                    if vm.currentRound < Constants.Rounds.maxRounds {
                                        vm.startNextRound()
                                    } else {
                                        vm.resetGame()
                                        dismiss()
                                    }
                                },
                                onExit: {
                                    vm.updateHighestWave()
                                    vm.resetGame()
                                    dismiss()
                                }
                            )
                        }
                }
                
                // MARK: Ability buttons
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ForEach(vm.abilities) { ability in
                            AbilityButtonView(
                                ability: ability,
                                onTap: {
                                    vm.useAbility(ability.type)
                                }
                            )
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                vm.loadAbilities()
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
    
    // MARK: Countdown view
    private func countdownView(count: Int) -> some View {
        Text("\(count)")
            .mFont(50)
            .transition(.scale)
    }
    
    // MARK: Game view
    private func gameView(in geometry: GeometryProxy) -> some View {
        ZStack {
            // MARK: Timer
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
            
            // MARK: Falling items
            ForEach(vm.items) { item in
                ItemView(
                    item: item,
                    screenHeight: geometry.size.height,
                    currentRound: vm.currentRound,
                    onTap: {
                        vm.tapItem(item)
                    },
                    onFall: {
                        vm.handleItemFall(item)
                    }
                )
            }
            
            // MARK: Active Shield Overlay
            if vm.isShieldActive {
                Color.blue
                    .opacity(0.15)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
            }
            
            // MARK: Penalty Overlay
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

#Preview {
    GameView()
}
