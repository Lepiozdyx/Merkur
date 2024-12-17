//
//  LoadingView.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            MainBGView()
            
            VStack {
                Image(.sun)
                    .resizable()
                    .frame(width: 170, height: 170)
                    .shadow(color: .yellow, radius: isAnimating ? 4 : 0)
                    .scaleEffect(isAnimating ? 1 : 0.98)
                    .animation(
                        .easeInOut(duration: 0.3)
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                Text("LOADING...")
                    .mFont(40)
            }
        }
        .onAppear {
            isAnimating.toggle()
        }
    }
}

#Preview {
    LoadingView()
}
