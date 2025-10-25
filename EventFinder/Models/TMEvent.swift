import Foundation

// Root response for /events.json
struct TMEventResponse: Decodable {
    let _embedded: TMEmbeddedEventsResponse?
    let page: Page?
}

struct Page: Decodable {
    let size: Int?
    let totalElements: Int?
    let totalPages: Int?
    let number: Int?
}

struct TMEmbeddedEventsResponse: Decodable {
    let events: [TMEvent]
}

struct TMEvent: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let url: URL?
    let images: [TMImage]?
    let dates: TMDates
    let _embedded: TMEventEmbedded?
    // Attraction info sometimes in "attractions" under _embedded
    var attractions: [TMAttraction]? { _embedded?.attractions }
    
    struct TMImage: Decodable, Hashable {
        let url: URL
        let width: Int?
        let height: Int?
    }
    
    // MARK: - Hashable & Equatable using id only
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TMEvent, rhs: TMEvent) -> Bool {
        lhs.id == rhs.id
    }
}

struct TMDates: Decodable, Hashable {
    let start: TMStart
}

struct TMStart: Decodable, Hashable {
    let localDate: String?
    let localTime: String?
    let dateTime: String?
}

struct TMEventEmbedded: Decodable, Hashable {
    let venues: [TMVenue]?
    let attractions: [TMAttraction]?
}

struct TMVenue: Decodable, Hashable {
    let id: String
    let name: String
    let address: TMAddress?
    let city: TMLocal?
    let country: TMLocal?
    let location: TMLocation?
    let postalCode: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TMVenue, rhs: TMVenue) -> Bool {
        lhs.id == rhs.id
    }
}

struct TMAddress: Decodable, Hashable {
    let line1: String?
}

struct TMLocal: Decodable, Hashable {
    let name: String?
}

struct TMLocation: Decodable, Hashable {
    let latitude: String?
    let longitude: String?
}

struct TMAttraction: Decodable, Hashable {
    let id: String?
    let name: String?
    let url: URL?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TMAttraction, rhs: TMAttraction) -> Bool {
        lhs.id == rhs.id
    }
}
