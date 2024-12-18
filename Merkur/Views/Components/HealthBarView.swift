//
//  HealthBarView.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import SwiftUI

struct HealthBarView: View {
    let width: CGFloat
    let height: CGFloat
    let healthBarWidth: CGFloat
    
    var body: some View {
        Image(.health)
            .resizable()
            .frame(maxWidth: width, maxHeight: height)
            .overlay(alignment: .leading) {
                Rectangle()
                    .frame(width: healthBarWidth, height: height/2.6)
                    .foregroundStyle(.pink)
                    .opacity(0.8)
                    .offset(x: 61)
                    .animation(.easeInOut(duration: 0.3), value: healthBarWidth)
            }
    }
}

#Preview {
    HealthBarView(width: 210, height: 50, healthBarWidth: 140)
}
