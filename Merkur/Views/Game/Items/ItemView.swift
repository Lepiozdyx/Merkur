//
//  ItemView.swift
//  Merkur
//
//  Created by Alex on 19.12.2024.
//

import SwiftUI

struct ItemView: View {
    let item: GameItem
    let screenHeight: CGFloat
    let onTap: () -> Void
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        Image(item.type.image)
            .resizable()
            .frame(width: Constants.Screen.itemSize, height: Constants.Screen.itemSize)
            .position(x: item.position.x, y: item.position.y + offset)
            .opacity(item.isEnabled ? 1 : 0)
            .onTapGesture {
                guard item.isEnabled else { return }
                onTap()
            }
            .onAppear {
                withAnimation(.linear(duration: Constants.Play.itemFallingDuration)) {
                    offset = screenHeight + Constants.Screen.itemSize * 2
                }
            }
    }
}
