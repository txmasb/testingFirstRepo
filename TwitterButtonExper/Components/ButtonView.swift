//
//  ButtonView.swift
//  TwitterButtonExper
//
//  Created by Tomás Boo Becerra on 19/12/24.
//

import SwiftUI



struct LoadingButton: View {
    
    @Binding var loadingState: LoadingState
    
    var action: () -> Void
    
    var isActive: Bool {
        loadingState != .idle
    }
    
    var body: some View {
        Button{
            action()
        } label: {
            HStack(spacing: 10){
                if isActive {
                    ToastStatusIcon(loadingState: $loadingState)
                        .transition(.scale)
                }
                Text(buttonLabel)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: true, vertical: true)
                    .contentTransition(.interpolate)
                    .transition(.scale.combined(with: .blurReplace))
            }
            .frame(height: 52)
            .padding(.leading, isActive ? 12 : 36)
            .padding(.trailing, isActive ? 24 : 36)
            .background(backgroundColor)
            .clipShape(.capsule)
        }
        .animation(.bouncy(duration: 0.2), value: loadingState)
        .disabled(loadingState == .loading)
    }
    
    var buttonLabel: String {
        switch loadingState {
        case .idle:
            "Confirm"
        case .loading:
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

struct CheckmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Starting point
        let startX = rect.minX + rect.width * 0.15
        let startY = rect.minY + rect.height * 0.52
        
        // Middle point
        let midX = rect.minX + rect.width * 0.4
        let midY = rect.minY + rect.height * 0.78
        
        // End Point
        let endX = rect.minX + rect.width * 0.85
        let endY = rect.minY + rect.height * 0.3
        
        // Drawing the checkmark
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: midX, y: midY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        return path
    }
}


struct ExclamationShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Vertical line
        let lineX = rect.midX
        let lineTopY = rect.minY + rect.height * 0.04
        let lineBottomY = rect.minY + rect.height * 0.46
        let lineWidth = rect.width * 0.1
        
        path.addRoundedRect(in: CGRect(
            x: lineX - lineWidth / 2,
            y: lineTopY,
            width: lineWidth,
            height: lineBottomY - lineTopY),
            cornerSize: CGSize(width: lineWidth / 2, height: lineWidth / 2)
        )
        
        // Dot
        let dotDiameter = rect.width * 0.15
        let dotX = rect.midX - dotDiameter / 2
        let dotY = rect.minY + rect.height * 0.79

        path.addEllipse(in: CGRect(
            x: dotX,
            y: dotY,
            width: dotDiameter,
            height: dotDiameter)
        )
        
        return path
    }
}
