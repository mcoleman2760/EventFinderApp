// Views/ScheduleView.swift
import SwiftUI
import SwiftData

struct ScheduleView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \SavedEvent.date, order: .forward)  var saved: [SavedEvent]

    var body: some View {
        NavigationView {
            List {
                ForEach(saved) { s in
                    VStack(alignment: .leading) {
                        Text(s.name).font(.headline)
                        Text(s.venueName).font(.subheadline).foregroundColor(.secondary)
                        Text(s.date, style: .date).font(.caption)
                    }
                    .padding(.vertical, 6)
                }
                .onDelete { idx in
                    for i in idx {
                        let item = saved[i]
                        context.delete(item)
                    }
                    do { try context.save() } catch { context.rollback() }
                }
            }
            .navigationTitle("My Schedule")
        }
    }
}
