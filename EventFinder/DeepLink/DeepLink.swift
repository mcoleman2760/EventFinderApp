// DeepLink/DeepLink.swift
import Foundation

enum DeepLink {
    case event(id: String)

    init?(url: URL) {
        guard url.scheme == "eventfinder" else { return nil }
        switch url.host {
        case "event":
            guard let id = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?.first(where: { $0.name == "id" })?.value, !id.isEmpty else { return nil }
            self = .event(id: id)
        default:
            return nil
        }
    }
}
