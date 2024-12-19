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
    
    @State private var isDamaged = false
    @State private var previousHealth: CGFloat = 0
    
    var body: some View {
        Image(.health)
            .resizable()
            .frame(maxWidth: width, maxHeight: height)
            .overlay(alignment: .leading) {
                // Health bar
                Rectangle()
                    .frame(width: healthBarWidth, height: height/2.6)
                    .foregroundStyle(.pink)
                    .shadow(
                        color: isDamaged ? .red : .pink,
                        radius: isDamaged ? 6 : 2
                    )
                    .opacity(isDamaged ? 0.9 : 0.8)
                    .offset(x: 53)
                    .animation(.easeInOut(duration: 0.3), value: healthBarWidth)
                    .onChange(of: healthBarWidth) { newWidth in
                        // Show damage effect when health decreases
                        if newWidth < previousHealth {
                            isDamaged = true
                            // Schedule damage effect to be removed
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                isDamaged = false
                            }
                        }
                        previousHealth = newWidth
                    }
            }
            .onAppear {
                previousHealth = healthBarWidth
            }
    }
}

#Preview {
    HealthBarView(width: 180, height: 50, healthBarWidth: 100)
}
