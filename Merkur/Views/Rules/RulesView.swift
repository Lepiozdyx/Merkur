//
//  RulesView.swift
//  Merkur
//
//  Created by Alex on 22.12.2024.
//

import SwiftUI

struct RulesView: View {
    @StateObject private var webManager = WebManager()
    
    var body: some View {
        WebViewManager(url: WebManager.rulesURL, webManager: webManager)
    }
}

#Preview {
    RulesView()
}
