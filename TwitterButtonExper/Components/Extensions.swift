//
//  Extensions.swift
//  OriginalTemplate
//
//  Created by Tomás Boo Becerra on 24/10/24.
//


import UIKit
import CoreImage
import Foundation
import SwiftUI
import SwiftData
import LocalAuthentication


import SwiftUI

struct HasScrolled: ViewModifier {
    @Binding var hasScrolled: Bool

    func body(content: Content) -> some View {
        content
            .background(
                Color.clear
                    .frame(height: 72)
                    .onScrollVisibilityChange { visible in
                        withAnimation {
                            hasScrolled = !visible
                        }
                    },
                alignment: .top
            )
    }
}

// Usage extension
extension View {
    func hasScrolled(_ hasScrolled: Binding<Bool>) -> some View {
        self.modifier(HasScrolled(hasScrolled: hasScrolled))
    }
}


struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}



extension View {
    func pulsingOpacity() -> some View {
        self
            .modifier(PulsingOpacityModifier(isAnimating: false))
    }
}

struct PulsingOpacityModifier: ViewModifier {
    @State var isAnimating: Bool
    private let duration = 0.6 // Fixed duration

    func body(content: Content) -> some View {
        content
            .opacity(isAnimating ? 0.3 : 1.0)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: duration)
                        .repeatForever(autoreverses: true)
                ) {
                    isAnimating = true
                }
            }
    }
}


//
//public struct ShakeEffect: GeometryEffect {
//    private let amount: CGFloat = 10.0
//    private let shakesPerUnit: CGFloat = 3.0
//    public var animatableData: CGFloat
//
//    public init(animatableData: CGFloat) {
//        self.animatableData = animatableData
//    }
//    
//    public func effectValue(size: CGSize) -> ProjectionTransform {
//        ProjectionTransform(
//            CGAffineTransform(
//                translationX: self.amount * sin(self.animatableData * .pi * self.shakesPerUnit),
//                y: 0.0
//            )
//        )
//    }
//}

struct HapticFeedback {
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}


func previewSetup<Content: View>(_ content: Content) -> some View {
    content
    
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


//extension UINavigationController: UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//    }
//    
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//}
//


struct MeasureHeightModifier: ViewModifier {
    @Binding var sheetContentHeight: CGFloat
    @Environment(\.presentationMode) var presentationMode
    func body(content: Content) -> some View {
        content
            .presentationBackground(.clear)
            .overlay(Rectangle()
                .frame(width: 48, height: 5)
                .foregroundColor(.grey100)
                .cornerRadius(10)
                .padding(.top, 10)
                .padding(.bottom, 4), alignment: .top)
//            .overlay(
//                Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {Image("cross-light")})
//                    .buttonStyle(BouncyIconStyle())
//                    .offset(x: -28, y: 28)
//                ,alignment: .topTrailing)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            sheetContentHeight = proxy.size.height
                        }
                        .onChange(of: proxy.size.height) {
                            withAnimation(.spring(duration: 0.3)) {
                                sheetContentHeight = proxy.size.height
                            }
                        }
                }
            )
            .padding(.horizontal, 16)
        
    }
}


extension View {
    func authenticateWithFaceID(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        // Check if Face ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to proceed"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false) // Face ID not available
            }
        }
    }
}




extension View {
    func measureHeight(sheetContentHeight: Binding<CGFloat>) -> some View {
        self.modifier(MeasureHeightModifier(sheetContentHeight: sheetContentHeight))
    }
    
    func customSheetModifiers(sheetContentHeight: Binding<CGFloat>) -> some View {
        self
            .measureHeight(sheetContentHeight: sheetContentHeight)
            .presentationDetents([.height(sheetContentHeight.wrappedValue)])
    }
}






extension Font {
    enum OpenRundeWeight: String {
        case regular = "OpenRunde-Regular"
        case medium = "OpenRunde-Medium"
        case semibold = "OpenRunde-Semibold"
        case bold = "OpenRunde-Bold"
        // Add other cases as needed
    }
    
    static func openRunde(size: CGFloat, weight: OpenRundeWeight) -> Font {
        return .custom(weight.rawValue, size: size)
    }
}


extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}


struct BouncyIconStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .onChange(of: configuration.isPressed) {
                if configuration.isPressed {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            }
    }
}

struct BouncyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .onChange(of: configuration.isPressed) {
                if configuration.isPressed {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            }
    }
}

struct BouncyTabIconStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .rotationEffect(.degrees(configuration.isPressed ? 5 : 0))
            .onChange(of: configuration.isPressed) {
                if configuration.isPressed {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            }
    }
}



extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255,
                       green: CGFloat(bitmap[1]) / 255,
                       blue: CGFloat(bitmap[2]) / 255,
                       alpha: CGFloat(bitmap[3]) / 255)
    }
}



extension String {
    func formattedAddress() -> String {
        let prefix = self.prefix(6) // Includes "0xc8"
        let suffix = self.suffix(2) // Includes the last "21"
        return "\(prefix)...\(suffix)"
    }
}




struct ShimmerViewModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white, Color.white.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase * 300, y: phase * 300)
                .mask(content)
            )
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerViewModifier())
    }
}



struct CustomRoundedRectangle: Shape {
    var topLeftRadius: CGFloat
    var topRightRadius: CGFloat
    var bottomLeftRadius: CGFloat
    var bottomRightRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        
        // Top-left corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius))
        path.addQuadCurve(to: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY), control: topLeft)
        
        // Top-right corner
        path.addLine(to: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + topRightRadius), control: topRight)
        
        // Bottom-right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRightRadius))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - bottomRightRadius, y: rect.maxY), control: bottomRight)
        
        // Bottom-left corner
        path.addLine(to: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY - bottomLeftRadius), control: bottomLeft)
        
        path.closeSubpath()
        
        return path
    }
}



struct CurvyLineShape: Shape {
    var dataPoints: [CGFloat] // Values in normalized range (0.0 to 1.0)
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard dataPoints.count > 1 else { return path }
        
        let stepX = rect.width / CGFloat(dataPoints.count - 1)
        let points = dataPoints.enumerated().map { index, value in
            CGPoint(x: CGFloat(index) * stepX, y: rect.height - (value * rect.height))
        }
        
        path.move(to: points[0])
        
        for index in 1..<points.count {
            let current = points[index]
            let previous = points[index - 1]
            let midPoint = CGPoint(x: (current.x + previous.x) / 2, y: (current.y + previous.y) / 2)
            
            path.addQuadCurve(to: midPoint, control: previous)
        }
        
        if let lastPoint = points.last {
            path.addLine(to: lastPoint)
        }
        
        return path
    }
}


struct LineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
