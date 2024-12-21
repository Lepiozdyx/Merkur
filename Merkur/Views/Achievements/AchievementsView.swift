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
            
            VStack {
                HStack {
                    MenuButtonView {
                        dismiss()
                    }
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(vm.achievements) { achievement in
                            AchievementItemView(achievement: achievement)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AchievementsView()
}
