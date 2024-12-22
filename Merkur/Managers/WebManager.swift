//
//  WebManager.swift
//  Merkur
//
//  Created by Alex on 22.12.2024.
//

import UIKit

class WebManager: ObservableObject {
    @Published private(set) var provenURL: URL?
    
    private let storage: UserDefaults
    private var didSaveURL = false
    
    static let initialURL = URL(string: Constants.Keys.initial)!
    static let rulesURL = URL(string: Constants.Keys.rules)!
    
    init(storage: UserDefaults = .standard) {
        self.storage = storage
        loadProvenURL()
    }
    
    private func loadProvenURL() {
        if let urlString = storage.string(forKey: Constants.Keys.savedURL) {
            if let url = URL(string: urlString) {
                provenURL = url
                didSaveURL = true
            } else {
                print("Failed to load URL from string: \(urlString)")
            }
        } else {
            print("Failed")
        }
    }
    
    func checkURL(_ url: URL) {
        if didSaveURL {
            return
        }
        
        guard !isInvalidURL(url) else {
            return
        }
        
        storage.set(url.absoluteString, forKey: Constants.Keys.savedURL)
        provenURL = url
        didSaveURL = true
    }
    
    private func isInvalidURL(_ url: URL) -> Bool {
        let invalidURLs = ["about:blank", "about:srcdoc"]
        
        if invalidURLs.contains(url.absoluteString) {
            return true
        }
        
        if url.host?.contains(Constants.Keys.googleURL) == true {
            return true
        }
        
        return false
    }
    
    func checkInitialURL() async throws -> Bool {
        do {
            var request = URLRequest(url: Self.initialURL)
            request.setValue(getUAgent(forWebView: false), forHTTPHeaderField: "User-Agent")
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return false
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                return false
            }
            
            guard let finalURL = httpResponse.url else {
                return false
            }
            
            if finalURL.host?.contains(Constants.Keys.googleURL) == true {
                return false
            }
            
            return true

        } catch {
            return false
        }
    }
    
    func getUAgent(forWebView: Bool = false) -> String {
        if forWebView {
            let version = UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "_")
            let agent = "Mozilla/5.0 (iPhone; CPU iPhone OS \(version) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
            return agent
        } else {
            let agent = "TestRequest/1.0 CFNetwork/1410.0.3 Darwin/22.4.0"
            return agent
        }
    }
}
