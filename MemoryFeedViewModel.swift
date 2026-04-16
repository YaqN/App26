import SwiftUI

final class MemoryFeedViewModel: ObservableObject {
    @Published var entries: [MemoryEntry] = [
        .init(
            title: "Sunset Bike Ride",
            summary: "Captured voice notes and photos from the trail near the bay.",
            timestamp: Date.now.addingTimeInterval(-1800),
            mood: "Calm",
            tags: ["fitness", "sunset", "gratitude"],
            tint: .orange
        ),
        .init(
            title: "Brainstormed startup idea",
            summary: "Created a mini Notion-style page with action items and risks.",
            timestamp: Date.now.addingTimeInterval(-7200),
            mood: "Focused",
            tags: ["work", "ideas", "planning"],
            tint: .blue
        ),
        .init(
            title: "Family dinner highlights",
            summary: "Wrote a quick journal recap and pinned favorite moments.",
            timestamp: Date.now.addingTimeInterval(-15000),
            mood: "Happy",
            tags: ["family", "food", "memories"],
            tint: .pink
        )
    ]

    @Published var continueWatching: [ContinueItem] = [
        .init(title: "Travel Dreamboard", nextStep: "Add spring 2026 wishlist", progress: 0.72, category: "Vision", tint: .purple),
        .init(title: "Mood tracker", nextStep: "Reflect on today", progress: 0.35, category: "Wellness", tint: .teal),
        .init(title: "Daily gratitude", nextStep: "Write your 3 wins", progress: 0.84, category: "Journal", tint: .indigo)
    ]

    func addEntry(title: String, summary: String, mood: String) {
        let newEntry = MemoryEntry(
            title: title,
            summary: summary,
            timestamp: .now,
            mood: mood,
            tags: ["new", "moment", "captured"],
            tint: .mint
        )
        entries.insert(newEntry, at: 0)
    }
}
