// ViewModels/SearchViewModel.swift
import Foundation
import Combine
import NetworkingKit

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var postalCode: String = ""      // if user chooses postal code search
    @Published var radius: Int = 25             // miles
    @Published var events: [TMEvent] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Put your Ticketmaster key here (or inject securely)
    private let apiKey = "DW0Cg50SCLS71LUGOJnEdazVdMr2ed6V"

    func searchByKeyword() async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://app.ticketmaster.com/discovery/v2/events.json?keyword=\(encoded)&apikey=\(apiKey)"
        await fetchEvents(urlString: urlString)
    }

    func searchByPostalCode() async {
        let trimmed = postalCode.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let urlString = "https://app.ticketmaster.com/discovery/v2/events.json?postalCode=\(trimmed)&radius=\(radius)&apikey=\(apiKey)"
        await fetchEvents(urlString: urlString)
    }

    private func fetchEvents(urlString: String) async {
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            let response: TMEventResponse = try await Networking.shared.fetch(url: url)
            self.events = response._embedded?.events ?? []
        } catch {
            self.errorMessage = error.localizedDescription
            self.events = []
        }
        isLoading = false
    }
}
