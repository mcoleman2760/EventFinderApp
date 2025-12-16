import SwiftUI

struct SettingsView: View {
    // Persist user settings using AppStorage
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("defaultPostalCode") private var defaultPostalCode = "10001"
    @AppStorage("defaultRadius") private var defaultRadius = 25

    var body: some View {
        NavigationStack {
            Form {
                // 🔘 Appearance Section
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                }

               

                // ℹ️ About Section
                Section(header: Text("About")) {
                  Label {
                      Text("EventFinder v1.0")
                  } icon: {
                      Image(systemName: "ticket.fill")
                      .modifier(CardIconModifier())
                          
                  }
                    Text("Discover concerts and events near you using Ticketmaster’s Discovery API.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
