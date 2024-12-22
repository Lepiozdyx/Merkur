//
//  ContentViewModel.swift
//  Merkur
//
//  Created by Alex on 22.12.2024.
//

import Foundation

enum AppState {
    case loading
    case webView
    case mainMenu
}

@MainActor
final class ContentViewModel: ObservableObject {
    @Published private(set) var appState: AppState = .loading
    
    private let storageManager: StorageManagerProtocol
    let webManager: WebManager
    
    init(
        storageManager: StorageManagerProtocol = StorageManager(),
        webManager: WebManager = WebManager()
    ) {
        self.storageManager = storageManager
        self.webManager = webManager
    }
    
    func onAppear() {
        Task {
            if webManager.provenURL != nil {
                appState = .webView
                return
            }
            
            do {
                if try await webManager.checkInitialURL() {
                    appState = .webView
                } else {
                    appState = .mainMenu
                }
            } catch {
                appState = .mainMenu
            }
        }
    }
}
