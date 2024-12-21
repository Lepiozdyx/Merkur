//
//  ToggleButtonView.swift
//  Merkur
//
//  Created by Alex on 21.12.2024.
//

import SwiftUI

struct ToggleButtonView: View {
    let name: String
    let isOn: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 10) {
                Text(name)
                    .mFont(28)
                
                Image(isOn ? .on : .off)
                    .resizable()
                    .frame(width: 120, height: 30)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        MainBGView()
        ToggleButtonView(name: "MUSIC", isOn: true, action: {})
    }
}
