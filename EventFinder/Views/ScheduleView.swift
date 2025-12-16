import SwiftUI
import SwiftData

struct ScheduleView: View {
    @Environment(\.modelContext) private var context

    // vm starts as nil because we cannot create it before we get the modelContext
    @State private var vm: ScheduleViewModel? = nil

    @Query(sort: \SavedEvent.date, order: .forward) var saved: [SavedEvent]

    var body: some View {
        NavigationView {
            List {
                ForEach(saved, id: \.id) { s in
                    VStack(alignment: .leading) {
                        Text(s.name).font(.headline)
                        Text(s.venueName).font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(s.date, style: .date)
                            .font(.caption)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .glassEffect(.regular.tint(.blue).interactive())
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("My Schedule")
            .onAppear {
                // If vm is still nil, now we have modelContext and can create it safely
                if vm == nil {
                    _vm.wrappedValue = ScheduleViewModel(context: context)
                }
            }
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        vm?.delete(at: offsets)
    }
}
