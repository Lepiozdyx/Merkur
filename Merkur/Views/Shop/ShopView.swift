//
//  ShopView.swift
//  Merkur
//
//  Created by Alex on 21.12.2024.
//

import SwiftUI

struct ShopView: View {
    @StateObject private var vm = ShopViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            MainBGView(isShop: true)
                
            VStack {
                HStack {
                    MenuButtonView {
                        dismiss()
                    }
                    Spacer()
                    
                    CounterBGView(
                        text: "\(vm.userData.coins)",
                        width: 160,
                        height: 45
                    )
                }
                .padding()
                
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(AbilityType.allCases, id: \.self) { ability in
                            ShopItemView(
                                ability: ability,
                                purchasedCount: vm.userData.purchasedAbilities.getCount(for: ability),
                                userCoins: vm.userData.coins,
                                onPurchase: {
                                    vm.purchaseAbility(ability)
                                }
                            )
                        }
                    }
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ShopView()
}
