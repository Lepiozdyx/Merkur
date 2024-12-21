//
//  MenuView.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import SwiftUI

struct MenuView: View {
    @StateObject private var vm = MenuViewModel()
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var isPortrait: Bool { verticalSizeClass == .regular }
    var isIPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    
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
                    
                    // Orientation message
                    if isPortrait && isIPhone {
                        Text("Tip: Play in landscape screen orientation")
                            .mFont(14)
                    }
                    
                    // Menu buttons
                    HStack(spacing: 20) {
                        NavigationLink {
                             GameView()
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
                             ShopView()
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
                        ActionView(
                            text: "BEST SCORE: WAVE \(vm.userData.wave)",
                            fontSize: 12,
                            width: 140,
                            height: 50
                        )
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
