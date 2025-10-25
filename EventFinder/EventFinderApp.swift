// EventFinderApp.swift
import SwiftUI
import SwiftData

@main
struct EventFinderApp: App {
    // configure SwiftData model container
    @StateObject private var deepLinkHandler = DeepLinkHandler()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(deepLinkHandler)
                .onOpenURL { url in
                    deepLinkHandler.handle(url)
                }
                .modelContainer(for: [SavedEvent.self])
        }
    }
}
