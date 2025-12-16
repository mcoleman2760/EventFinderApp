// Views/EventDetailView.swift
import SwiftUI
import MapKit
import SwiftData
import Combine

struct EventDetailView: View {
    @StateObject private var vm: EventDetailViewModel
    @Environment(\.modelContext) private var context

    // Holder for schedule tasks (view-owned state)
    @State private var scheduleVMHolder = ScheduleVMHolder()

    init(event: TMEvent) {
        _vm = StateObject(wrappedValue: EventDetailViewModel(event: event))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {

                AsyncImage(url: vm.event.images?.first?.url) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.frame(height: 220)
                    case .success(let img):
                        img.resizable()
                            .scaledToFill()
                            .frame(height: 220)
                            .clipped()
                    case .failure:
                        Color.gray.frame(height: 220)
                    @unknown default:
                        Color.gray.frame(height: 220)
                    }
                }

                Text(vm.event.name)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Date")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(vm.event.dates.start.localDate ?? "--")
                    }
                    Spacer()
                    if let attractionNames = vm.event.attractions?
                        .compactMap({ $0.name })
                        .joined(separator: ", ") {
                        VStack(alignment: .leading) {
                            Text("Artists")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(attractionNames)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(.horizontal)

                Divider()

                if let venue = vm.venue {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Venue").font(.headline)
                        Text(venue.name)
                        if let addr = venue.address?.line1 { Text(addr) }
                        if let city = venue.city?.name { Text(city) }
                        if let postal = venue.postalCode {
                            Text("Postal: \(postal)")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 6)

                    if let latStr = venue.location?.latitude,
                       let lonStr = venue.location?.longitude,
                       let lat = Double(latStr),
                       let lon = Double(lonStr) {
                        MapView(
                            coordinate: CLLocationCoordinate2D(
                                latitude: lat,
                                longitude: lon
                            )
                        )
                        .frame(height: 200)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                } else {
                    if vm.isLoadingVenue {
                        ProgressView().padding()
                    } else {
                        Text("Venue info not available")
                            .padding(.horizontal)
                    }
                }

                HStack {
                    Button {
                        if scheduleVMHolder.vm == nil {
                            scheduleVMHolder.vm =
                                ScheduleViewModel(context: context)
                        }
                        scheduleVMHolder.vm?.toggle(event: vm.event)
                    } label: {
                        let isSaved =
                            scheduleVMHolder.vm?.isSaved(vm.event) ?? false
                        Label(
                            "Save Event",
                            systemImage: isSaved
                                ? "bookmark.fill"
                                : "bookmark"
                        )
                        .padding()
                        .background(
                            isSaved
                                ? Color.blue
                                : Color.gray.opacity(0.3)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }

                    Spacer()

                    if let url = vm.event.url {
                        Link(destination: url) {
                            Label("Buy Tickets", systemImage: "ticket")
                                .padding()
                                .background(.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                Task { await vm.loadFullEvent() }
            }
        }
        .navigationTitle("Event")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Small holder to avoid creating ScheduleViewModel in init
    private final class ScheduleVMHolder {
        var vm: ScheduleViewModel? = nil
    }
}
