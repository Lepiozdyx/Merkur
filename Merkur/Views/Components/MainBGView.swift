//
//  MainBGView.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import SwiftUI

struct MainBGView: View {
    var isGamefield = false
    
    var body: some View {
        Image(.bg)
            .resizable()
            .overlay(alignment: .bottom) {
                if isGamefield {
                    Image(.earth)
                        .resizable()
                        .frame(width: .infinity, height: 70)
                }
            }
            .ignoresSafeArea()
    }
}

#Preview {
    MainBGView()
}
