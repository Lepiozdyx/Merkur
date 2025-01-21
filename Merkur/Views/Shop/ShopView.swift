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
    
    var isIPad: Bool { UIDevice.current.userInterfaceIdiom == .pad}
    
    var body: some View {
        ZStack {
            MainBGView()
                .blur(radius: 10, opaque: true)
            
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
                
                shopItemsLayout
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: Items Layout
    @ViewBuilder
    private var shopItemsLayout: some View {
        if isIPad {
            HStack(spacing: 20) {
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
            .padding(.horizontal)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
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
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ShopView()
}
