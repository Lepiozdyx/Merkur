//
//  HealthBarView.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import SwiftUI

struct HealthBarView: View {
    let width: CGFloat
    let height: CGFloat
    let healthBarWidth: CGFloat
    let currentHealth: Double
    
    @State private var isDamaged = false
    @State private var previousHealth: Double = Constants.Play.initialHealth
    
    private var currentHealthBarWidth: CGFloat {
        let healthPercentage = currentHealth / Constants.Play.initialHealth
        return min(healthBarWidth, healthBarWidth * CGFloat(healthPercentage))
    }
    
    var body: some View {
        Image(.health)
            .resizable()
            .frame(maxWidth: width, maxHeight: height)
            .overlay(alignment: .leading) {
                // Health bar
                Rectangle()
                    .frame(width: currentHealthBarWidth, height: height/2.6)
                    .foregroundStyle(.pink)
                    .shadow(
                        color: isDamaged ? .red : .pink,
                        radius: isDamaged ? 6 : 2
                    )
                    .opacity(isDamaged ? 0.9 : 0.8)
                    .offset(x: 53)
                    .animation(.easeInOut(duration: 0.3), value: currentHealthBarWidth)
            }
            .onChange(of: currentHealth) { newHealth in
                print("Health changed to:", newHealth) // Debug print
                if newHealth < previousHealth {
                    isDamaged = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isDamaged = false
                    }
                }
                previousHealth = newHealth
            }
            .onAppear {
                print("HealthBarView appeared with health:", currentHealth) // Debug print
                previousHealth = currentHealth
            }
    }
}

#Preview {
    HealthBarView(width: 180, height: 50, healthBarWidth: 100, currentHealth: 80)
}
