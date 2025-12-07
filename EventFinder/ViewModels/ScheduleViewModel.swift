import Foundation
import SwiftData
import Combine
import EventKit

@MainActor
final class ScheduleViewModel: ObservableObject {

    @Published private(set) var saved: [SavedEvent] = []

    private let context: ModelContext
    private let eventStore = EKEventStore()

    init(context: ModelContext) {
        self.context = context
        load()
    }

    // MARK: - Load all saved events from SwiftData
    func load() {
        let request = FetchDescriptor<SavedEvent>(
            predicate: nil,
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )

        do {
            saved = try context.fetch(request)
        } catch {
            print("Failed fetching saved events:", error)
            saved = []
        }
    }

    // MARK: - Check if event is already saved
    func isSaved(_ event: TMEvent) -> Bool {
        saved.contains { $0.id == event.id }
    }

    // MARK: - Save or toggle an event
    func toggle(event: TMEvent) {
        if isSaved(event) {
            remove(event: event)
        } else {
            save(event: event)
        }
    }

    // MARK: - Save event
    func save(event: TMEvent) {
        Task {
            guard let localDateString = event.dates.start.localDate,
                  let date = iso8601Date(from: localDateString)
            else { return }

            var calendarEventId: String? = nil

            do {
                let granted = try await eventStore.requestFullAccessToEvents()
                if granted {
                    let ek = EKEvent(eventStore: eventStore)
                    ek.title = event.name
                    ek.startDate = date
                    ek.endDate = date.addingTimeInterval(60 * 60)
                    ek.notes = event.url?.absoluteString
                    ek.calendar = eventStore.defaultCalendarForNewEvents
                    try eventStore.save(ek, span: .thisEvent)
                    calendarEventId = ek.eventIdentifier
                } else {
                    print("Calendar access denied by user")
                }
            } catch {
                print("Failed to save event to Calendar:", error)
            }

            let poster = event.images?.first?.url
            let venueName = event._embedded?.venues?.first?.name ?? ""

            let model = SavedEvent(
                id: event.id,
                name: event.name,
                date: date,
                venueName: venueName,
                posterURL: poster,
                calendarEventId: calendarEventId
            )

            context.insert(model)

            do {
                try context.save()
                load()
            } catch {
                context.rollback()
                print("Failed saving SavedEvent:", error)
            }
        }
    }

    // MARK: - Remove event
    func remove(event: TMEvent) {
        guard let model = saved.first(where: { $0.id == event.id }) else { return }

        // Remove calendar event if exists
        if let calId = model.calendarEventId,
           let ekEvent = eventStore.event(withIdentifier: calId) {
            do {
                try eventStore.remove(ekEvent, span: .thisEvent, commit: true)
            } catch {
                print("Failed to remove calendar event:", error)
            }
        }

        context.delete(model)

        do {
            try context.save()
            load()
        } catch {
            context.rollback()
            print("Failed removing SavedEvent:", error)
        }
    }

    // MARK: - Delete events by IndexSet (for list editing)
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let model = saved[index]

            // Remove calendar event if exists
            if let calId = model.calendarEventId,
               let ekEvent = eventStore.event(withIdentifier: calId) {
                do {
                    try eventStore.remove(ekEvent, span: .thisEvent, commit: true)
                } catch {
                    print("Failed removing calendar event:", error)
                }
            }

            context.delete(model)
        }

        do {
            try context.save()
            load()
        } catch {
            context.rollback()
            print("Failed deleting events:", error)
        }
    }

    // MARK: - Helpers
    private func iso8601Date(from localDate: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        return formatter.date(from: localDate)
    }
}
