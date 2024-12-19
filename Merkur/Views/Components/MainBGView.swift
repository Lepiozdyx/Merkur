//
//  MainBGView.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import SwiftUI

struct MainBGView: View {
    var isGamefield = false
    var isShop = false
    
    var body: some View {
        Image(isShop ? .bgShop : .bg)
            .resizable()
            .overlay(alignment: .bottom) {
                if isGamefield {
                    VStack(spacing: 40) {
                        Image(.sun)
                            .resizable()
                            .frame(width: 90, height: 90)
                            .shadow(color: .yellow, radius: 3)
                            .opacity(0.8)
                        
                        Image(.earth)
                            .resizable()
                            .frame(width: .infinity, height: 70)
                    }
                }
            }
            .ignoresSafeArea()
    }
}

#Preview {
    MainBGView()
}
