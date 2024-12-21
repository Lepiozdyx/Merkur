//
//  MenuButtonView.swift
//  Merkur
//
//  Created by Alex on 19.12.2024.
//

import SwiftUI

struct MenuButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(.buttonUnderlay)
                .resizable()
                .frame(width: 50, height: 45)
                .overlay {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
        }
        .withSound()
    }
}

#Preview {
    MenuButtonView(action: {})
}
