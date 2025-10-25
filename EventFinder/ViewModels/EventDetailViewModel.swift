// ViewModels/EventDetailViewModel.swift
import Foundation
import NetworkingKit
import Combine

@MainActor
final class EventDetailViewModel: ObservableObject {
  // var objectWillChange: ObservableObjectPublisher
  
    @Published var event: TMEvent
    @Published var venue: TMVenue?
    @Published var isLoadingVenue = false
    @Published var errorMessage: String?

    private let apiKey = "DW0Cg50SCLS71LUGOJnEdazVdMr2ed6V"

    init(event: TMEvent) {
        self.event = event
      self.venue = nil
              self.isLoadingVenue = false
      self.errorMessage = nil
    }

    /// Use /events/{eventId}.json to fetch full event details (includes venue)
    func loadFullEvent() async {
        guard let url = URL(string: "https://app.ticketmaster.com/discovery/v2/events/\(event.id).json?apikey=\(apiKey)") else { return }
        isLoadingVenue = true
        do {
            // We can decode a TMEvent (the endpoint returns event object). Use same TMEvent struct.
            let fullEvent: TMEvent = try await Networking.shared.fetch(url: url)
            self.event = fullEvent
            self.venue = fullEvent._embedded?.venues?.first
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoadingVenue = false
    }

    /// Alternatively fetch venue directly by /venues/{id}.json
    func loadVenueById(_ venueId: String) async {
        guard let url = URL(string: "https://app.ticketmaster.com/discovery/v2/venues/\(venueId).json?apikey=\(apiKey)") else { return }
        isLoadingVenue = true
        do {
            let v: TMVenue = try await Networking.shared.fetch(url: url)
            self.venue = v
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoadingVenue = false
    }
}
