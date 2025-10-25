// Views/RootView.swift
import SwiftUI
import NetworkingKit

struct RootView: View {
    @EnvironmentObject private var deepLinkHandler: DeepLinkHandler
    @Environment(\.modelContext) private var context

    var body: some View {
        TabView {
            DiscoverView()
                .tabItem { Label("Discover", systemImage: "magnifyingglass.circle") }

          ScheduleView()
                .tabItem { Label("Schedule", systemImage: "bookmark") }
        }
        .onChange(of: deepLinkHandler.pendingEventId) { oldValue, newValue in
            guard let id = newValue else { return }
            Task {
                await handleDeepLinkToEvent(id)
            }
        }

    }

    /// Fetch event by id and present detail by pushing onto navigation.
    func handleDeepLinkToEvent(_ id: String) async {
        // Fetch event details from Ticketmaster
        let key = "DW0Cg50SCLS71LUGOJnEdazVdMr2ed6V"
        guard let url = URL(string: "https://app.ticketmaster.com/discovery/v2/events/\(id).json?apikey=\(key)") else { return }
        do {
            let event: TMEvent = try await Networking.shared.fetch(url: url)
            // Present the EventDetail by posting a notification or using a navigation path
            // Simpler: set deepLink to nil and show an alert with event info or open a new window
            // For full navigation: integrate a NavigationStack and push EventDetailView(event:)
            NotificationCenter.default.post(name: .didReceiveDeepLinkEvent, object: event)
        } catch {
            print("Deep link event fetch failed:", error)
        }
        deepLinkHandler.clear()
    }
}

extension Notification.Name {
    static let didReceiveDeepLinkEvent = Notification.Name("didReceiveDeepLinkEvent")
}
