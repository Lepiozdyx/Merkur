//
//  MenuViewModel.swift
//  Merkur
//
//  Created by Alex on 19.12.2024.
//

import Foundation
import Combine

final class MenuViewModel: ObservableObject {
    @Published private(set) var userData: UserData = .empty
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        AppStateService.shared.userDataPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.userData, on: self)
            .store(in: &cancellables)
    }
}
