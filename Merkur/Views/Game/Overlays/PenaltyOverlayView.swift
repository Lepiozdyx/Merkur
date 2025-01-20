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
            Color.red.opacity(0.1).ignoresSafeArea()
            
            Text("You destroy human rocket! 5 second penalty")
                .mFont(20)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.red.opacity(0.3))
                .cornerRadius(10)
        }
    }
}

#Preview {
    PenaltyOverlayView()
}
