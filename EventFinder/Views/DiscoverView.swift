import SwiftUI
import SwiftData
import Combine

struct DiscoverView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var searchVM = SearchViewModel()
    @StateObject private var scheduleVMHolder = ScheduleVMHolder()
    
    let columns = [GridItem(.adaptive(minimum: 160), spacing: 12)]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                
                // MARK: Search Fields
                HStack(spacing: 8) {
                    TextField("Search artist, city or keyword", text: $searchVM.query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit { Task { await searchVM.searchByKeyword() } }
                    
                    Button("Search") { Task { await searchVM.searchByKeyword() } }
                }
                .padding(.horizontal)
                
                HStack(spacing: 8) {
                    TextField("Postal code (optional)", text: $searchVM.postalCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numbersAndPunctuation)
                    
                    Stepper("\(searchVM.radius) mi", value: $searchVM.radius, in: 1...200)
                        .frame(width: 130)
                }
                .padding(.horizontal)
                
                HStack {
                    Button(action: { Task { await searchVM.searchByPostalCode() } }) {
                        Label("Search Near Postal Code", systemImage: "location.circle")
                    }
                    Spacer()
                    if searchVM.isLoading {
                        ProgressView()
                    }
                }
                .padding(.horizontal)
                
                if let err = searchVM.errorMessage {
                    Text(err)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                // MARK: Events Grid with animation
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(searchVM.events) { event in
                            NavigationLink(value: event) {
                                if let scheduleVM = scheduleVMHolder.vm {
                                    EventCardView(event: event, scheduleVM: scheduleVM)
                                        .transition(.scale.combined(with: .opacity)) // animate appearance
                                } else {
                                    ProgressView()
                                        .frame(height: 150)
                                }
                            }
                        }
                    }
                    .padding()
                    // Animate changes to the events array
                    .animation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.5), value: searchVM.events)
                }
            }
            .navigationTitle("EventFinder")
            .navigationDestination(for: TMEvent.self) { event in
                EventDetailView(event: event)
            }
            .onAppear {
                if scheduleVMHolder.vm == nil {
                    scheduleVMHolder.vm = ScheduleViewModel(context: modelContext)
                }
                
                // Load initial events
                Task {
                    await searchVM.searchByKeyword()
                }
            }
        }
    }
    
    // MARK: ScheduleVM Holder
    private final class ScheduleVMHolder: ObservableObject {
        @Published var vm: ScheduleViewModel? = nil
    }
}
