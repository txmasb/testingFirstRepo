//
//  LoginView.swift
//  TwitterButtonExper
//
//  Created by Tomás Boo Becerra on 19/12/24.
//

import SwiftUI

struct LoginFlow: View {
    
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                OnboardingHeader(viewModel: viewModel)
                TabView(selection: $viewModel.selectedTab) {
                    LoginView(viewModel: viewModel)
                        .tag(0)
                    Text("ConfirmationView")
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .overlay(
                ToastView(loadingState: $viewModel.loginState)
                , alignment: .top)
            .onChange(of: viewModel.email) {
                viewModel.loginState = .idle
            }
            .onChange(of: viewModel.loginState) { newState in
                if newState == .succeeded {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation{
                            viewModel.selectedTab += 1
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    LoginFlow()
//        .environment(\.colorScheme, .dark)
}



struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 40){
//            Image(systemName: "person.crop.circle.fill")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 56, height: 56)
//                .foregroundStyle(.blue400, .blue50)
//                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 12) {
                Text("Login With Email")
                    .font(.system(size: 28, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Please enter a valid email and password.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.grey300)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(spacing: 24){
                
                ValidField(text: $viewModel.email, isValid: $viewModel.isValid)
                
                SecureField("Password", text: $viewModel.password)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.grey900)
                    .padding(16)
                    .padding(.horizontal, 4)
                    .background(.grey0)
                    .clipShape(.rect(cornerRadius: 16))
                    .disabled(viewModel.loginState == .loading)
            }
            Button{
                Task{
                    await viewModel.login()
                }
            } label: {
                Text("Confirm")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(height: 52)
                    .frame(maxWidth: .infinity)
                    .background(.blue400)
                    .clipShape(.rect(cornerRadius: 18))
            }
            .disabled(viewModel.loginState != .idle)
            .buttonStyle(BouncyButtonStyle())
            Spacer()
        }
        .padding(32)
    }
}

struct OnboardingHeader: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            HStack(spacing: 8) {
                Button{
                    if viewModel.selectedTab >= 1 {
                        withAnimation{
                            viewModel.selectedTab -= 1
                        }
                    }
                } label: {
                    Image("back")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundStyle(viewModel.selectedTab == 0 ? .grey200 : .grey200)
                }
                .disabled(viewModel.selectedTab == 0)
                .buttonStyle(BouncyIconStyle())
                Spacer()
                Button{
                    if viewModel.selectedTab <= 1 {
                        withAnimation{
                            viewModel.selectedTab += 1
                        }
                    }
                } label: {
                    Text("Help")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(viewModel.selectedTab >= 2 ? .grey200 : .grey300)
                }
                .disabled(viewModel.selectedTab >= 2)
                .buttonStyle(BouncyIconStyle())
            }
            
            HStack(spacing: 6){
                ForEach(0..<3) { circle in
                    Capsule()
                        .fill(circle == viewModel.selectedTab ? .blue400 : .grey100)
                        .frame(width: circle == viewModel.selectedTab ? 24 : 8, height: 8)
                        .animation(.easeInOut, value: viewModel.selectedTab)
                }
            }
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 12)
    }
}


struct ConfirmationView: View {
    var body: some View {
        VStack{
            Text("You're Logged In!")
            
        }
    }
}
