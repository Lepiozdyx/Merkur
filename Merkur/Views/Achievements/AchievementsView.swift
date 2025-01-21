//
//  AchievementsView.swift
//  Merkur
//
//  Created by Alex on 21.12.2024.
//

import SwiftUI

struct AchievementsView: View {
    @StateObject private var vm = AchievementsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            MainBGView()
                .blur(radius: 10, opaque: true)
            
            VStack {
                HStack {
                    MenuButtonView {
                        dismiss()
                    }
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                TabView {
                    ForEach(vm.achievements) { achievement in
                        AchievementItemView(achievement: achievement)
                    }
                    .padding(.bottom, 40)
                }
                .tabViewStyle(.page)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AchievementsView()
}
