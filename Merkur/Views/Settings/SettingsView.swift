//
//  SettingsView.swift
//  Merkur
//
//  Created by Alex on 21.12.2024.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()
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
                Spacer()
            }
            .padding()
            
            Image(.menuUnderlay)
                .resizable()
                .frame(maxWidth: 400, maxHeight: 350)
                .overlay(alignment: .top) {
                    Text("SETTINGS")
                        .mFont(16)
                        .padding(.top, 5)
                }
            
            VStack(spacing: 20) {
                ToggleButtonView(name: "SOUNDS", isOn: vm.isSoundEnabled) {
                    withAnimation {
                        vm.toggleSound()
                    }
                }
                
                ToggleButtonView(name: "MUSIC", isOn: vm.isMusicEnabled) {
                    withAnimation {
                        vm.toggleMusic()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SettingsView()
}
