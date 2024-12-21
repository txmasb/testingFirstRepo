//
//  ToastView.swift
//  TwitterButtonExper
//
//  Created by Tomás Boo Becerra on 20/12/24.
//

import SwiftUI


struct ToastView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var loadingState: LoadingState
    @State private var isVisible: Bool = false
    
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    
    let showHideDuration: TimeInterval = 0.4
    
    var backgroundColor: Color {
        Color(colorScheme == .light ? UIColor.systemBackground : UIColor.secondarySystemBackground)
    }
    
    var toastLabel: String {
        switch loadingState {
        case .idle, .loading:
            "Confirming"
        case .succeeded:
            "Confirmed"
        case .failed:
            "Failed"
        }
    }
    
    var body: some View {
        HStack(spacing: 10){
            ToastStatusIcon(loadingState: $loadingState)
                .transition(.scale)
            Text(toastLabel)
                .font(.system(size: 20, weight: .bold))
                .contentTransition(.interpolate)
                .transition(.scale.combined(with: .blurReplace))
        }
        .frame(height: 48)
        .padding(.leading, 12)
        .padding(.trailing, 24)
        .background(backgroundColor)
        .clipShape(.capsule)
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
        .offset(y: isVisible ? 8 : -140)
        .opacity(isVisible ? 1 : 0)
        .animation(.snappy(duration: showHideDuration), value: isVisible) // In-Out Animation
        .animation(.bouncy(duration: 0.3), value: loadingState) // State Morphing Animation
        .onChange(of: loadingState) {
            handleStateChange()
        }
    }
    
    func handleStateChange() {
        switch loadingState {
        case .idle:
            isVisible = false
        case .loading:
            isVisible = true
        case .succeeded:
            feedbackGenerator.notificationOccurred(.success)
            hideToast(after: 1.2)
        case .failed:
            feedbackGenerator.notificationOccurred(.error)
            hideToast(after: 1.2)
        }
    }
    
    private func hideToast(after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            isVisible = false
            // Back to idle once is hiddennn
            DispatchQueue.main.asyncAfter(deadline: .now() + showHideDuration) {
                loadingState = .idle
            }
        }
    }
}



struct ToastStatusIcon: View {
    
    @Binding var loadingState: LoadingState
    @State private var trimEnd: CGFloat = 0.0
    
    let color: Color = .green500
    
    var isLoading: Bool {
        loadingState == .loading
    }
    
    var body: some View {
        ZStack {
            switch loadingState {
            case .idle, .loading:
                loadingCircle(laodingState: $loadingState, color: color)
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
    
    @Binding var laodingState: LoadingState
    let color: Color
    
    var isAnimating: Bool {
        laodingState == .loading
    }
    
    var body: some View {
        Circle()
            .trim(from: 0.0, to: 0.3)
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .foregroundColor(color)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .animation(.linear(duration: 0.2).repeatForever(autoreverses: false), value: isAnimating)
//            .onAppear {
//                withAnimation(Animation.linear(duration: 0.25).repeatForever(autoreverses: false)) {
//                    isAnimating = true
//                }
//            }
    }
}
