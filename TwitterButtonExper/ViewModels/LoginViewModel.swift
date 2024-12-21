//
//  LoginViewModel.swift
//  TwitterButtonExper
//
//  Created by Tomás Boo Becerra on 19/12/24.
//

import SwiftUI

enum LoadingState {
    case idle
    case loading
    case succeeded
    case failed
}


class LoginViewModel: ObservableObject {
    
    @Published var email = "eve.holt@reqres.in"
    @Published var password = "cityslicka"
    @Published var token: String?
    @Published var message = "Login"
    @Published var loginState: LoadingState = .idle
    @Published var isValid: Bool = true
    @Published var selectedTab = 0
    
    func login() async {
        
        self.loginState = .loading
        
        let urlString = "https://reqres.in/api/login"
        
        struct LoginResponse: Codable {
            let token: String
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            self.loginState = .failed
            return
        }
        
        let body: [String: String] = [
            "email": email,
            "password": password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Failed to create request body")
            self.loginState = .failed
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid server response")
                self.message = "Login failed"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    self.loginState = .failed
                    withAnimation(.bouncy){
                        self.isValid = false
                    }
                }
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                self.message = "You're Logged In. Token: \(decodedResponse.token)"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    self.loginState = .succeeded
//                    self.selectedTab = 1
                }
            }
            
        } catch {
            print("Error logging in: \(error)")
            self.message = "Login failed due to an error"
            self.loginState = .failed
            self.isValid = false
        }
    }

}


//print("Error logging in: \(error)")
//self.message = "Login failed due to an error"
//self.loginState = .failed


