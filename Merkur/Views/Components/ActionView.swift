//
//  ActionView.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import SwiftUI

struct ActionView: View {
    let text: String
    let fontSize: CGFloat
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Image(.buttonUnderlay)
            .resizable()
            .frame(maxWidth: width, maxHeight: height)
            .overlay {
                Text(text)
                    .mFont(fontSize)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
    }
}

#Preview {
    ZStack {
        MainBGView()
        ActionView(text: "ACHIEVEMENTS", fontSize: 30, width: 280, height: 100)
    }
}
