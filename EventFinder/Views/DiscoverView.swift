// Views/DiscoverView.swift
import SwiftUI

struct DiscoverView: View {
    @StateObject private var vm = SearchViewModel()
    let columns = [GridItem(.adaptive(minimum: 160), spacing: 12)]

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    TextField("Search artist, city or keyword", text: $vm.query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit { Task { await vm.searchByKeyword() } }

                    Button("Search") {
                        Task { await vm.searchByKeyword() }
                    }
                }.padding(.horizontal)

                HStack(spacing: 8) {
                    TextField("Postal code (optional)", text: $vm.postalCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numbersAndPunctuation)

                    Stepper("\(vm.radius) mi", value: $vm.radius, in: 1...200)
                        .frame(width: 130)
                }
                .padding(.horizontal)

                HStack {
                    Button(action: { Task { await vm.searchByPostalCode() } }) {
                        Label("Search Near Postal Code", systemImage: "location.circle")
                    }
                    Spacer()
                    if vm.isLoading { ProgressView() }
                }
                .padding(.horizontal)

                if let err = vm.errorMessage {
                    Text(err).foregroundColor(.red).font(.caption).padding(.horizontal)
                }

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(vm.events) { event in
                            NavigationLink(value: event) {
                                EventCardView(event: event) {
                                    // on favorite toggle — you may persist here using ScheduleViewModel context
                                }
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                                .animation(.easeOut(duration: 0.3), value: vm.events)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("EventFinder")
            .navigationDestination(for: TMEvent.self) { event in
                EventDetailView(event: event)
            }
        }
    }
}
