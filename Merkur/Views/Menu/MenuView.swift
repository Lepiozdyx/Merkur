//
//  MenuView.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MainBGView()
                
                // MARK: Coins
                HStack {
                    Spacer()
                    // Number of coins earned
                    CounterBGView(text: "0", width: 200, height: 51)
                }
                .padding()
                
                VStack(spacing: 10) {
                    Spacer()
                    Spacer()
                    HStack(spacing: 20) {
                        NavigationLink {
                            // GameView()
                        } label: {
                            ActionView(text: "START", fontSize: 28, width: 250, height: 80)
                        }
                        
                        NavigationLink {
                            // AchievementsView()
                        } label: {
                            ActionView(text: "ACHIEVEMENTS", fontSize: 28, width: 250, height: 80)
                        }
                    }
                    
                    HStack(spacing: 20) {
                        NavigationLink {
                            // ShopView()
                        } label: {
                            ActionView(text: "SHOP", fontSize: 28, width: 250, height: 80)
                        }
                        
                        NavigationLink {
                            // RulesView()
                        } label: {
                            ActionView(text: "RULES", fontSize: 28, width: 250, height: 80)
                        }
                    }
                    
                    NavigationLink {
                        // SettingsView()
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
                        // Saved best wave number
                        ActionView(text: "BEST SCORE: WAVE 5", fontSize: 14, width: 130, height: 60)
                    }
                }
                .padding()
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    MenuView()
}
