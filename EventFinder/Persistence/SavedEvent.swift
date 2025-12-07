// Persistence/SavedEvent.swift
import Foundation
import SwiftData

@Model final class SavedEvent {
    @Attribute(.unique) var id: String
    var name: String
    var date: Date
    var venueName: String
    var posterURL: URL?

    // NEW: store the system calendar event identifier so we can remove it later
    var calendarEventId: String?

    init(id: String, name: String, date: Date, venueName: String, posterURL: URL?, calendarEventId: String? = nil) {
        self.id = id
        self.name = name
        self.date = date
        self.venueName = venueName
        self.posterURL = posterURL
        self.calendarEventId = calendarEventId
    }
}

extension SavedEvent {
    static func isEventSaved(_ id: String, in context: ModelContext? = nil) -> Bool {
        guard let ctx = context else { return false }

        let descriptor = FetchDescriptor<SavedEvent>(
            predicate: #Predicate { $0.id == id }
        )

        let results = (try? ctx.fetch(descriptor)) ?? []
        return !results.isEmpty
    }
}
