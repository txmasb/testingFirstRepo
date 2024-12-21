//
//  ValidField.swift
//  TwitterButtonExper
//
//  Created by Tomás Boo Becerra on 20/12/24.
//

import SwiftUI

struct ValidField: View {
    
    @FocusState var isFocused
    
    @State private var isShaking = false
    
    @Binding var text: String
    @Binding var isValid: Bool
    
    var body: some View {
        TextField("", text: $text,
                  prompt:
                    Text(isValid ? "New timer name..." : "Please enter a name")
                .foregroundStyle(isValid ? .grey300 : .red500))
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(.grey800)
            .focused($isFocused)
            .padding(16)
            .padding(.horizontal, 4)
            .background(isValid ? .grey0 : .white)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(lineWidth: 2).foregroundStyle(.red500.opacity(isValid ? 0 : 1)))
            .overlay(
                Group {
                    if !isValid {
                        Image("warning")
                            .foregroundStyle(.red500)
                            .padding(.trailing, 24)
                    }
                },
                alignment: .trailing
            )
            .modifier(ShakeEffect(animatableData: isShaking ? 0 : 1))
            .onChange(of: isValid){
                withAnimation(.bouncy){
                    isShaking = true
                }
            }
            .onChange(of: text) {
                if !text.isEmpty {
                    withAnimation(.bouncy) {
                        isValid = true
                    }
                }
            }
    }
}


public struct ShakeEffect: GeometryEffect {
    private let amount: CGFloat = 5
    private let shakesPerUnit: CGFloat = 6
    public var animatableData: CGFloat

    public init(animatableData: CGFloat) {
        self.animatableData = animatableData
    }
    
    public func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: self.amount * sin(self.animatableData * .pi * self.shakesPerUnit),
                y: 0.0
            )
        )
    }
}
