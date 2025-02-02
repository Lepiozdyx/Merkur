//
//  MenuView.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import SwiftUI

struct MenuView: View {
    @StateObject private var vm = MenuViewModel()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MainBGView()
                
                // MARK: Coins
                HStack {
                    Spacer()
                    CounterBGView(
                        text: "\(vm.userData.coins)",
                        width: 160,
                        height: 45
                    )
                }
                .padding()
                
                VStack(spacing: 10) {
                    Spacer()
                    Spacer()
                    
                    // Menu buttons
                    HStack(spacing: 20) {
                        NavigationLink {
                             GameView()
                        } label: {
                            ActionView(text: "START", fontSize: 28, width: 250, height: 80)
                        }
                        
                        NavigationLink {
                             AchievementsView()
                        } label: {
                            ActionView(text: "ACHIEVEMENTS", fontSize: 28, width: 250, height: 80)
                        }
                    }
                    
                    HStack(spacing: 20) {
                        NavigationLink {
                             ShopView()
                        } label: {
                            ActionView(text: "SHOP", fontSize: 28, width: 250, height: 80)
                        }
                        
                        NavigationLink {
                             RulesView()
                        } label: {
                            ActionView(text: "RULES", fontSize: 28, width: 250, height: 80)
                        }
                    }
                    
                    NavigationLink {
                         SettingsView()
                    } label: {
                        ActionView(text: "SETTINGS", fontSize: 28, width: 250, height: 80)
                    }
                    
                    Spacer()
                }
                .padding()
                
                // MARK: Best score
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(.achUnderlay)
                            .resizable()
                            .frame(maxWidth: 130, maxHeight: 50)
                            .overlay {
                                Text("BEST SCORE: WAVE \(vm.userData.wave)")
                                    .mFont(12)
                                    .padding(.horizontal)
                            }
                    }
                }
                .padding()
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            SoundManager.shared.updateMusicState()
        }
    }
}

#Preview {
    MenuView()
}
