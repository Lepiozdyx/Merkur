//
//  ShopItemView.swift
//  Merkur
//
//  Created by Alex on 21.12.2024.
//

import SwiftUI

struct ShopItemView: View {
    let ability: AbilityType
    let purchasedCount: Int
    let userCoins: Int
    let onPurchase: () -> Void
    
    private var canPurchase: Bool {
        userCoins >= ability.price
    }
    
    var body: some View {
        Image(.achUnderlay)
            .resizable()
            .frame(maxWidth: 290, maxHeight: 300)
            .overlay {
                VStack(spacing: 16) {
                    Image(ability.image)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .overlay(alignment: .bottomTrailing) {
                            // Purchased Count
                            if purchasedCount > 0 {
                                Text("x\(purchasedCount)")
                                    .mFont(14)
                                    .padding(6)
                                    .background(Color.blue.opacity(0.7))
                                    .clipShape(.rect(cornerRadius: 10))
                            }
                        }
                    
                    VStack(spacing: 4) {
                        Text(ability.abilityName)
                            .mFont(14)
                        
                        Text(ability.abilityDescription)
                            .mFont(10)
                    }
                    
                    HStack {
                        Image(.coin)
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("\(ability.price)")
                            .mFont(14)
                    }
                    .background(
                        Image(.priceFrame)
                            .resizable()
                            .frame(width: 80, height: 30)
                    )
                    
                    // Buy Button
                    Button {
                        onPurchase()
                    } label: {
                        ActionView(text: "BUY", fontSize: 20, width: 160, height: 45)
                    }
                    .disabled(!canPurchase)
                    .opacity(canPurchase ? 1 : 0.5)
                }
            }
    }
}

#Preview {
    ShopItemView(ability: AbilityType.shield, purchasedCount: 1, userCoins: 1, onPurchase: {})
}
