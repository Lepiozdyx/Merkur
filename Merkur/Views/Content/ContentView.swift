//
//  ContentView.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ContentViewModel()
    
    var body: some View {
        Group {
            switch vm.appState {
            case .loading:
                LoadingView()
            case .webView:
                if let url = vm.webManager.provenURL {
                    WebViewManager(url: url, webManager: vm.webManager)
                } else {
                    WebViewManager(url: WebManager.initialURL, webManager: vm.webManager)
                }
            case .mainMenu:
                MenuView()
            }
        }
        .onAppear {
            vm.onAppear()
        }
    }
}

#Preview {
    ContentView()
}
