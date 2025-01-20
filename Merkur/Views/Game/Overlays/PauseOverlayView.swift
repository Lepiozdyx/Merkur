//
//  PauseOverlayView.swift
//  Merkur
//
//  Created by Alex on 18.12.2024.
//

import SwiftUI

struct PauseOverlayView: View {
    let onResume: () -> Void
    let onExit: () -> Void
    
    var body: some View {
        Color.black.opacity(0.5)
            .ignoresSafeArea()
            .overlay {
                ZStack {
                    Image(.menuUnderlay)
                        .resizable()
                        .frame(maxWidth: 400, maxHeight: 350)
                        .overlay(alignment: .top) {
                            Text("PAUSE")
                                .mFont(18)
                                .offset(y: 35)
                        }
                    
                    VStack(spacing: 20) {
                        Button {
                            onResume()
                        } label: {
                            ActionView(
                                text: "RESUME",
                                fontSize: 28,
                                width: 250,
                                height: 70
                            )
                        }
                        
                        Button {
                            onExit()
                        } label: {
                            ActionView(
                                text: "MENU",
                                fontSize: 28,
                                width: 250,
                                height: 70
                            )
                        }
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
    }
}

#Preview {
    PauseOverlayView(onResume: {}, onExit: {})
}
