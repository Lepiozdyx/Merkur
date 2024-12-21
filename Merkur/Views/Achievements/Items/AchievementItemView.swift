//
//  AchievementItemView.swift
//  Merkur
//
//  Created by Alex on 21.12.2024.
//

import SwiftUI

struct AchievementItemView: View {
    let achievement: Achievement
    @State private var isAnimating = false
    
    var body: some View {
        Image(achievement.type.image)
            .resizable()
            .frame(width: 250, height: 200)
            .blur(radius: achievement.isUnlocked ? 0 : 10)
            .overlay {
                if !achievement.isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                        .opacity(0.5)
                        .offset(y: 15)
                }
            }
            .shadow(
                color: achievement.isUnlocked ? .yellow : .clear,
                radius: isAnimating ? 14 : 8
            )
            .scaleEffect(achievement.isUnlocked && isAnimating ? 1 : 0.98)
            .animation(
                .easeInOut(duration: 0.7)
                .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                if achievement.isUnlocked {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    ZStack {
        MainBGView()
        AchievementItemView(
            achievement: Achievement.init(type: .balanceKeeper, isUnlocked: false)
        )
    }
}
