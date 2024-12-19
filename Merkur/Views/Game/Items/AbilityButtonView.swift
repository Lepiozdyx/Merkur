//
//  AbilityButtonView.swift
//  Merkur
//
//  Created by Alex on 18.12.2024.
//

import SwiftUI

struct AbilityButtonView: View {
    let ability: Ability
    let onTap: () -> Void
    
    var body: some View {
        Button {
            if ability.count > 0 && !ability.isActive {
                onTap()
            }
        } label: {
            Image(ability.type.image)
                .resizable()
                .frame(width: 60, height: 60)
                .opacity(ability.count > 0 && !ability.isActive ? 1 : 0.5)
        }
        .disabled(ability.count == 0 || ability.isActive)
        .overlay(alignment: .topTrailing) {
            if ability.count > 0 {
                Text("\(ability.count)")
                    .mFont(14)
                    .padding(4)
                    .background(
                        Circle()
                            .fill(.red.opacity(0.8))
                    )
                    .offset(x: 10, y: -10)
            }
        }
    }
}

#Preview {
    AbilityButtonView(
        ability: Ability(type: .shield, count: 2, isActive: false),
        onTap: {}
    )
}
