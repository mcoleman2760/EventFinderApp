// Views/EventCardView.swift
import SwiftUI

struct EventCardView: View {
    let event: TMEvent
    @State private var isFavorited = false
    var onFavoriteToggle: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: event.images?.first?.url) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.gray.opacity(0.2)
                        ProgressView()
                    }
                    .frame(height: 120)
                case .success(let img):
                    img.resizable().scaledToFill().frame(height: 120).clipped()
                case .failure:
                    Color.gray.frame(height: 120)
                @unknown default:
                    Color.gray.frame(height: 120)
                }
            }

            Text(event.name)
                .font(.headline)
                .lineLimit(2)

            HStack {
                Text(event.dates.start.localDate ?? "--")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                        isFavorited.toggle()
                        onFavoriteToggle?()
                    }
                } label: {
                    Image(systemName: isFavorited ? "bookmark.fill" : "bookmark")
                        .scaleEffect(isFavorited ? 1.15 : 1.0)
                        .modifier(CardIconModifier())
                }
            }

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


