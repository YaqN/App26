import SwiftUI

struct MemoryEntry: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let timestamp: Date
    let mood: String
    let tags: [String]
    let tint: Color
}

struct ContinueItem: Identifiable {
    let id = UUID()
    let title: String
    let nextStep: String
    let progress: Double
    let category: String
    let tint: Color
}
