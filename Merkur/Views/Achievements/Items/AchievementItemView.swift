//
//  AchievementItemView.swift
//  Merkur
//
//  Created by Alex on 21.12.2024.
//

import SwiftUI

struct AchievementItemView: View {
    let achievement: Achievement
    
    var body: some View {
        Image(achievement.type.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 250)
            .blur(radius: achievement.isUnlocked ? 0 : 5)
            .overlay {
                if !achievement.isUnlocked {
                    VStack {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                            .opacity(0.7)
                        
                        Text("LOCKED")
                            .mFont(12)
                    }
                    .offset(y: 15)
                }
            }
            .shadow(
                color: achievement.isUnlocked ? .yellow : .clear,
                radius: 10
            )
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
