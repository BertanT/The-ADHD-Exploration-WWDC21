import SwiftUI

// I am scaling up the dynmaic fonts for better looks on Mac!
// Scale the fonts by 1.5 times if using a 13 inch MacBook or smaller, scale them up by 1.8 times if using a Mac with a higher screen resolution
// Was only tested on 15/16 and 13 inch MacBooks, feel free to edit the following line to adapt to the resoulution of your Mac
let fontScalingCoefficent: CGFloat = UIScreen.main.bounds.height < 1100 ? 1.25 : 1.8

// Predefining gradients used throughout the Playground to make code cleaner
public extension Gradient {
    // Some hand dandy predefined gradients
    static var tealGradient = Gradient(colors: [UIColor.systemTeal, UIColor.systemGreen].map { Color($0) })
    static var indigoGradient = Gradient(colors: [UIColor.systemIndigo, UIColor.systemTeal].map { Color($0) })
    static var orangeGradient = Gradient(colors: [UIColor.systemOrange, UIColor.systemPink].map { Color($0) })
    static var purpleGradient = Gradient(colors: [Color(UIColor.systemPurple), Color(UIColor.systemPink)])
    static var redGradient = Gradient(colors: [UIColor.systemRed, UIColor.systemPink].map { Color($0) })
    
    // Some fancy,
    // Computed property,
    // Some Fruit Company,
    // Gredient out here.
    
    // Those colors... Seem familiar somehow
    static func sixColorGradient(colorRange: ClosedRange<Int>? = nil) -> Gradient {
        let sixColors = [UIColor](arrayLiteral: .systemGreen, .systemYellow, .systemOrange, .systemRed, .systemPurple, .systemBlue).map { Color($0) }
        
        if let range = colorRange, sixColors.indices.contains(range.lowerBound), sixColors.indices.contains(range.upperBound)  {
            return Gradient(colors: Array(sixColors[range]))
            
        }else {
            return Gradient(colors: sixColors)
        }
    }
}

// A view modifier that scales up dymaic fonts and uses rounded design as default for better looks!
// I used a bit of a hack here, but it works ;)
fileprivate struct ScaledFont: ViewModifier {
    let style: UIFont.TextStyle
    let design: Font.Design = .rounded
    let weight: Font.Weight = .regular
    public func body(content: Content) -> some View {
        content
            .font(.system(size: (UIFont.preferredFont(forTextStyle: style).pointSize * fontScalingCoefficent), weight: weight, design: .rounded))
    }
}

// A view modifier that enables views to have gradient fills, and adds some shadow too!
fileprivate struct GradientBackground: ViewModifier {
    let gradient: Gradient
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    let effectRadius: CGFloat
    let glows: Bool
    public func body(content: Content) -> some View {
        content
            .overlay(LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint))
            .mask(content)
            .glow(radius: glows ? effectRadius : 0)
            .shadow(radius: !glows ? effectRadius : 0)
    }
}

// Turning custom view modifiers to extension functions for them to be used like built-in modifier
// Example: ".myModifier()" instead of ".modifier(MyModifier())"
public extension View {
    func largeRoundedFont(_ style: UIFont.TextStyle) -> some View {
        self.modifier(ScaledFont(style: style))
    }
    func gradientBackground(gradient: Gradient, startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing, effectRadius: CGFloat = 15, glows: Bool = true) -> some View {
        self.modifier(GradientBackground(gradient: gradient, startPoint: startPoint, endPoint: endPoint, effectRadius: effectRadius, glows: glows))
    }
    
    // A custom colorful glow modifier!
    public func glow(radius: CGFloat = 15) -> some View {
        ZStack {
            // Don't add an overlay if the radius is set to 0, it can look weird
            if radius != 0 {
                self.overlay(self.blur(radius: radius)).opacity(0.5)
            }
            self
        }
    }
}

// The animated gradient button used all throughout the playground.
// Using ButtonStyle for cleaner code
public struct GradientButton: ButtonStyle {
    private let gradient: Gradient
    private let disabled: Bool
    
    public init(gradient: Gradient, disabled: Bool = false) {
        self.gradient = gradient
        self.disabled = disabled
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .largeRoundedFont(.title2)
            // Show gradient only if the button is enabled.
            // Decrease the glow/shadow radius as the button is pressed
            .gradientBackground(gradient: disabled ? Gradient(colors: [.gray]) : gradient, effectRadius: disabled ? 0 : (configuration.isPressed ? 0 : 15))
            // Scale down the button as it is pressed
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            // A cool bouncing spring animation!
            .animation(.spring(response: 0.4))
    }
}


