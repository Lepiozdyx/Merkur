//
//  StartButtonView.swift
//  Merkur
//
//  Created by Alex on 19.12.2024.
//

import SwiftUI

struct StartButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ActionView(text: "START", fontSize: 28, width: 250, height: 70)
        }
    }
}

#Preview {
    ZStack {
        MainBGView()
        StartButtonView(action: {})
    }
}
