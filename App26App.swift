import SwiftUI

@main
struct App26App: App {
    @StateObject private var viewModel = MemoryFeedViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
