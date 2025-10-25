// DeepLink/DeepLinkHandler.swift
import Foundation
import SwiftUI
import Combine

@MainActor
final class DeepLinkHandler: ObservableObject {
    @Published var pendingEventId: String?

    func handle(_ url: URL) {
        guard let dl = DeepLink(url: url) else { return }
        switch dl {
        case .event(let id): pendingEventId = id
        }
    }

    func clear() { pendingEventId = nil }
}
