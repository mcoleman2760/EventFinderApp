// Views/Modifiers.swift
import SwiftUI

struct CardStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.regularMaterial)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
            .padding(4)
    }
}
extension View {
    func cardStyle() -> some View { modifier(CardStyleModifier()) }
}

struct CardIconModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(6)
            .background(Color(white: 0.95))
            .clipShape(Circle())
    }
}
