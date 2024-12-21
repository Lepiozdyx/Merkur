//
//  Ext+View.swift
//  Merkur
//
//  Created by Alex on 21.12.2024.
//

import SwiftUI

struct ButtonSoundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture().onEnded {
                    SoundManager.shared.playSound(.click)
                }
            )
    }
}
extension View {
    func withSound() -> some View {
        modifier(ButtonSoundModifier())
    }
}
