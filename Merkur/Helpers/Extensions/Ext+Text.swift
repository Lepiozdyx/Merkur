//
//  Ext+Text.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import SwiftUI

extension Text {
    func mFont(_ size: CGFloat) -> some View {
        self
            .foregroundStyle(.white)
            .font(.system(size: size, weight: .heavy, design: .monospaced))
            .multilineTextAlignment(.center)
    }
}

struct Ext_Text: View {
    var body: some View {
        Text("LOADING...")
            .mFont(40)
    }
}

#Preview {
    ZStack {
        MainBGView()
        Ext_Text()
    }
}
