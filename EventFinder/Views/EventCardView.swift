// Views/EventCardView.swift
import SwiftUI

struct EventCardView: View {
    let event: TMEvent
    @ObservedObject var scheduleVM: ScheduleViewModel   // observe saved events

    // Compute favorite status from ScheduleViewModel
    private var isFavorited: Bool {
        scheduleVM.saved.contains(where: { $0.id == event.id })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // MARK: Event Image
            AsyncImage(url: event.images?.first?.url) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.gray.opacity(0.2)
                        ProgressView()
                    }
                    .frame(height: 120)
                case .success(let img):
                    img.resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                case .failure:
                    Color.gray.frame(height: 120)
                @unknown default:
                    Color.gray.frame(height: 120)
                }
            }

            // MARK: Event Name
            Text(event.name)
                .font(.headline)
                .lineLimit(2)

            // MARK: Date + Bookmark
            HStack {
                Text(event.dates.start.localDate ?? "--")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Button {
                    if isFavorited {
                        scheduleVM.delete(event: event)   // remove from saved
                    } else {
                        scheduleVM.save(event: event)     // add to saved
                    }
                } label: {
                    Image(systemName: isFavorited ? "bookmark.fill" : "bookmark")
                        .scaleEffect(isFavorited ? 1.15 : 1.0)
                        .modifier(CardIconModifier()) //maybe delete
                        .animation(.spring(response: 0.35, dampingFraction: 0.6), value: isFavorited)
                }
            }

            // MARK: Artists
            if let names = event.attractions?.compactMap({ $0.name }).joined(separator: ", "), !names.isEmpty {
                Text(names)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .padding()
        .cardStyle()
    }
}

// MARK: ScheduleViewModel Helper
extension ScheduleViewModel {
    func delete(event: TMEvent) {
        if let index = saved.firstIndex(where: { $0.id == event.id }) {
            delete(at: IndexSet(integer: index))
        }
    }
}
