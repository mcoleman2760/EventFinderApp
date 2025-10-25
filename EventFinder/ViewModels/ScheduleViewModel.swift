// ViewModels/ScheduleViewModel.swift
import Foundation
import SwiftData
import Combine

@MainActor
final class ScheduleViewModel: ObservableObject {
  var objectWillChange: ObservableObjectPublisher
  
    @Published var saved: [SavedEvent] = []
    private var context: ModelContext

    init(context: ModelContext) {
              self.context = context
              self.saved = []                    // ✅ initialize all @Published
              self.objectWillChange = .init()    // ✅ initialize before using self
              load()
    }

    func load() {
        let req = FetchDescriptor<SavedEvent>(predicate: nil, sortBy: [SortDescriptor(\.date, order: .forward)])
        do {
            saved = try context.fetch(req)
        } catch {
            saved = []
        }
    }

    func save(event: TMEvent) {
        guard let dateString = event.dates.start.localDate,
              let date = iso8601Date(from: dateString) else { return }
        let poster = event.images?.first?.url
        let venueName = event._embedded?.venues?.first?.name ?? ""
        let model = SavedEvent(id: event.id, name: event.name, date: date, venueName: venueName, posterURL: poster)
        context.insert(model)
        do {
            try context.save()
            load()
        } catch {
            context.rollback()
            print("Save failed:", error)
        }
    }

    func delete(at offsets: IndexSet) {
        for idx in offsets {
            let s = saved[idx]
            context.delete(s)
        }
        do {
            try context.save()
            load()
        } catch {
            context.rollback()
        }
    }

    private func iso8601Date(from localDate: String) -> Date? {
        // localDate is "YYYY-MM-DD"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        return formatter.date(from: localDate)
    }
}
