//
//  ToastView.swift
//  TwitterButtonExper
//
//  Created by Tomás Boo Becerra on 20/12/24.
//

import SwiftUI


struct ToastView: View {
    
    @Binding var loadingState: LoadingState
    @State private var isActive: Bool = false
    
    var body: some View {
        HStack(spacing: 10){
            ToastStatusIcon(loadingState: $loadingState)
                .transition(.scale)
            Text(buttonLabel)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.grey900)
                .contentTransition(.interpolate)
                .transition(.scale.combined(with: .blurReplace))
        }
        .frame(height: 48)
        .padding(.leading, 12)
        .padding(.trailing, 24)
        .background(.white)
        .clipShape(.capsule)
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
        .offset(y: isActive ? 8 : -140)
        .opacity(isActive ? 1 : 0)
        .animation(.snappy(duration: 0.4), value: isActive)
        .animation(.bouncy(duration: 0.3), value: loadingState)
        .onChange(of: loadingState) {
            showToast()
        }
    }
    
    func showToast() {
        switch loadingState {
        case .idle:
            isActive = false
        case .loading:
            isActive = true
        case .succeeded, .failed:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isActive = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                    loadingState = .idle
                }
            }
        }
    }
    
    var buttonLabel: String {
        switch loadingState {
        case .idle, .loading:
            "Confirming"
        case .succeeded:
            "Confirmed"
        case .failed:
            "Failed"
        }
    }
    
    var backgroundColor: Color {
        switch loadingState {
        case .idle:
                .blue
        case .loading:
                .blue
        case .succeeded:
                .green
        case .failed:
                .red
        }
    }
}



struct ToastStatusIcon: View {
    
    @Binding var loadingState: LoadingState
    
    @State private var trimEnd: CGFloat = 0.0
    @State private var isAnimating = false
    
    let color: Color = .blue400
    
    var isLoading: Bool {
        loadingState == .loading
    }
    
    var body: some View {
        ZStack {
            switch loadingState {
            case .idle, .loading:
                loadingCircle(color: color)
                    .frame(width: 20, height: 20)
                    .transition(.blurReplace)
            case .succeeded:
                Circle()
                    .fill(color)
                    .frame(width: 24, height: 24)
                    .scaleEffect(!isLoading ? 1 : 0)
                    .transition(.scale)
                CheckmarkShape()
                    .trim(from: 0, to: trimEnd)
                    .stroke(.white, style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))
                    .frame(width: 14, height: 14)
            case .failed:
                Circle()
                    .fill(.red500)
                    .frame(width: 24, height: 24)
                    .scaleEffect(!isLoading ? 1 : 0)
                    .transition(.scale)
                ExclamationShape()
                    .stroke(.white, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .frame(width: 14, height: 14)
                    .transition(.scale)
            }
//            if loadingState == .idle || loadingState == .loading {
//                loadingCircle(color: color)
//                    .frame(width: 20, height: 20)
//                    .transition(.blurReplace)
//            }
//            if loadingState == .succeeded {
//                Circle()
//                    .fill(color)
//                    .frame(width: 24, height: 24)
//                    .scaleEffect(!isLoading ? 1 : 0)
//                    .transition(.scale)
//                CheckmarkShape()
//                    .trim(from: 0, to: trimEnd)
//                    .stroke(.white, style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))
//                    .frame(width: 14, height: 14)
//            }
//            if loadingState == .failed {
//                Circle()
//                    .fill(.red500)
//                    .frame(width: 24, height: 24)
//                    .scaleEffect(!isLoading ? 1 : 0)
//                    .transition(.scale)
//                ExclamationShape()
//                    .stroke(.white, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
//                    .frame(width: 14, height: 14)
//                    .transition(.scale)
//            }
        }
        .frame(width: 24, height: 24)
        .animation(.bouncy(duration: 0.2), value: loadingState)
        .onChange(of: loadingState) {
            if loadingState ==  .succeeded {
                withAnimation(.bouncy(duration: 0.2)) {
                    trimEnd = 1
                }
            }
        }
    }
}


struct loadingCircle: View {
    
    @State private var isAnimating = false
    let color: Color
    
    var body: some View {
        Circle()
            .trim(from: 0.0, to: 0.3)
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .foregroundColor(color)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(Animation.linear(duration: 0.25).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}
