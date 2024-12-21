//
//  ShopViewModel.swift
//  Merkur
//
//  Created by Alex on 21.12.2024.
//

import Foundation
import Combine

@MainActor
final class ShopViewModel: ObservableObject {
    @Published private(set) var userData: UserData = .empty
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        AppStateService.shared.userDataPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.userData, on: self)
            .store(in: &cancellables)
    }
    
    func purchaseAbility(_ type: AbilityType) {
        AppStateService.shared.purchaseAbility(type)
    }
}
