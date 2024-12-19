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
    let onFall: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var hasFallen = false
    
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
                print("Item appeared:", item.type)
                
                // Start falling animation
                withAnimation(.linear(duration: Constants.Play.itemFallingDuration)) {
                    offset = screenHeight + Constants.Screen.itemSize * 2
                }
                
                // Schedule fall event for when animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Play.itemFallingDuration) {
                    if !hasFallen && item.isEnabled {
                        hasFallen = true
                        print("Item falling:", item.type)
                        onFall()
                    }
                }
            }
    }
}
