# 🎟️ EventFinder

EventFinder is a SwiftUI iOS app that helps users discover concerts and live events near them using Ticketmaster’s Discovery API. Users can browse events, view details, and save favorites for later.

---

## ✨ Features

- 🔍 Discover concerts and events near you  
- 📍 View venue name and event date  
- ❤️ Save events for quick access  
- 🗑️ Delete saved events with swipe gestures  
- 🎨 Modern SwiftUI design  
- 🪟 Optional Glass UI effects on newer iOS versions (with graceful fallback)  


---

## 🛠️ Tech Stack

- SwiftUI  
- iOS  
- Ticketmaster Discovery API  
- MVVM-style architecture  
- Swift concurrency / async networking (if applicable)  

---

## 🚀 Getting Started

### Requirements

- Xcode 15+  
- iOS 15+ (Glass effects enabled on iOS 26+)  
- A Ticketmaster API key  

### Installation

1. Clone the repository:

```bash
git clone https://github.com/your-username/EventFinder.git



Open the project in Xcode:

open EventFinder.xcodeproj


Add your Ticketmaster API key
Create a constants file or environment variable:

let ticketmasterAPIKey = "YOUR_API_KEY"


Build and run on a simulator or device.

### **🌐 Ticketmaster API**

This app uses the Ticketmaster Discovery API to fetch event data.

Website: https://developer.ticketmaster.com/

You must register for a free API key.

🪟 Glass UI Compatibility

EventFinder uses modern SwiftUI features like glassEffect when available:

iOS 26+ → Glass UI enabled

Older iOS versions → Automatic fallback to native materials

This ensures the app looks great without breaking compatibility.

📂 Project Structure
EventFinder
├── Models
├── Views
├── ViewModels
├── Networking
└── Utilities

🧪 Known Limitations

Event availability depends on Ticketmaster data

Location-based filtering may vary by region

🗺️ Future Improvements

🔔 Event reminders & notifications

🧭 Map-based event browsing

🔐 User accounts & cloud sync

🎟️ Ticket purchasing deep links

📄 License

This project is for educational and personal use.
Ticketmaster data is subject to their terms of service.

👤 Author

Created by Michael Coleman

If you like this project, feel free to ⭐️ the repo!
