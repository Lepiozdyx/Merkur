//
//  TimeShiftOverlayView.swift
//  Merkur
//
//  Created by Alex on 18.12.2024.
//

import SwiftUI

struct TimeShiftOverlayView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.blue
                .opacity(0.05)
                .ignoresSafeArea()
            
            HStack {
                Text("Time shift mode")
                    .mFont(16)
                    .padding(4)
                    .border(.white, width: 1)
                Spacer()
            }
            .padding()
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    ZStack {
        MainBGView()
        TimeShiftOverlayView()
    }
}
