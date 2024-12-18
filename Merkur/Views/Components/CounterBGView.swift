//
//  CounterBGView.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import SwiftUI

struct CounterBGView: View {
    let text: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Image(.coinsUnderlay)
            .resizable()
            .frame(maxWidth: width, maxHeight: height)
            .overlay {
                Text(text)
                    .mFont(18)
                    .multilineTextAlignment(.center)
                    .offset(x: 20)
                    .animation(.bouncy, value: text)
            }
    }
}

#Preview {
    CounterBGView(text: "123", width: 210, height: 50)
}
