//
//  PenaltyOverlayView.swift
//  Merkur
//
//  Created by Alex on 18.12.2024.
//

import SwiftUI

struct PenaltyOverlayView: View {
    var body: some View {
        ZStack {
            Color.red
                .opacity(0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("WRONG TARGET!")
                    .mFont(24)
                
                Text("weapons system reboot...")
                    .mFont(24)
            }
            .padding()
            .border(.white, width: 2)
        }
    }
}

#Preview {
    PenaltyOverlayView()
}
