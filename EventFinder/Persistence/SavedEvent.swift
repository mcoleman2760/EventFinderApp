// Persistence/SavedEvent.swift
import Foundation
import SwiftData

@Model
final class SavedEvent {
    @Attribute(.unique) var id: String
    var name: String
    var date: Date
    var venueName: String
    var posterURL: URL?

    init(id: String, name: String, date: Date, venueName: String, posterURL: URL?) {
        self.id = id
        self.name = name
        self.date = date
        self.venueName = venueName
        self.posterURL = posterURL
    }
}
