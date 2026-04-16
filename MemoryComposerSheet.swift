import SwiftUI

struct MemoryComposerSheet: View {
    @EnvironmentObject private var viewModel: MemoryFeedViewModel
    @Binding var isPresented: Bool

    @State private var title = ""
    @State private var summary = ""
    @State private var mood = "Inspired"

    private let moods = ["Inspired", "Happy", "Calm", "Focused", "Reflective"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Memory") {
                    TextField("Title", text: $title)
                    TextField("What happened?", text: $summary, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Current mood") {
                    Picker("Mood", selection: $mood) {
                        ForEach(moods, id: \.self) { mood in
                            Text(mood)
                        }
                    }
                }

                Section {
                    Label("Timestamp: \(Date.now, format: .dateTime.hour().minute().second())", systemImage: "clock")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Add Memory")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.addEntry(
                            title: title.isEmpty ? "Untitled Moment" : title,
                            summary: summary.isEmpty ? "Quick thought captured." : summary,
                            mood: mood
                        )
                        isPresented = false
                    }
                    .disabled(title.isEmpty && summary.isEmpty)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
