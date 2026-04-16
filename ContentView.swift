import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: MemoryFeedViewModel
    @State private var showComposer = false

    var body: some View {
        ZStack {
            AnimatedBackdropView()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 26) {
                    HeaderView()

                    ContinueSectionView(items: viewModel.continueWatching)

                    JournalTimelineView(entries: viewModel.entries)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }

            VStack {
                Spacer()

                HStack {
                    Spacer()
                    AddMemoryButton {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showComposer.toggle()
                        }
                    }
                    .padding(.trailing, 22)
                    .padding(.bottom, 24)
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showComposer) {
            MemoryComposerSheet(isPresented: $showComposer)
        }
    }
}

private struct HeaderView: View {
    @EnvironmentObject private var viewModel: MemoryFeedViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Memory Studio")
                .font(.system(size: 34, weight: .bold, design: .rounded))

            Text("\(Date.now, format: .dateTime.weekday(.wide).month().day()) • \(Date.now, format: .dateTime.hour().minute())")
                .font(.callout)
                .foregroundStyle(.white.opacity(0.7))

            Text("Capture moments like Netflix episodes and organize thoughts like Notion pages.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))

            if let latest = viewModel.entries.first {
                FeaturedMemoryCard(entry: latest)
                    .padding(.top, 4)
            }
        }
    }
}

private struct ContinueSectionView: View {
    let items: [ContinueItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Continue your story")
                .font(.title3.bold())

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(items) { item in
                        ContinueCard(item: item)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

private struct JournalTimelineView: View {
    let entries: [MemoryEntry]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Journal timeline")
                .font(.title3.bold())

            ForEach(entries) { entry in
                TimelineRow(entry: entry)
            }
        }
        .padding(.bottom, 88)
    }
}

private struct FeaturedMemoryCard: View {
    let entry: MemoryEntry
    @State private var animateGlow = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.pink.opacity(0.6), Color.purple.opacity(0.45), Color.black.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                }
                .shadow(color: .purple.opacity(animateGlow ? 0.65 : 0.2), radius: animateGlow ? 28 : 10)
                .frame(height: 220)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true)) {
                        animateGlow = true
                    }
                }

            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title)
                    .font(.title2.bold())
                Text(entry.summary)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(2)
                HStack {
                    Label("\(entry.timestamp, format: .dateTime.hour().minute())", systemImage: "clock")
                    Spacer()
                    Text(entry.mood)
                }
                .font(.caption)
                .foregroundStyle(.white.opacity(0.82))
            }
            .padding(20)
        }
    }
}

private struct ContinueCard: View {
    let item: ContinueItem
    @State private var showProgress = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(item.tint.gradient)
                .frame(width: 180, height: 108)
                .overlay(alignment: .topLeading) {
                    Text(item.category)
                        .font(.caption.bold())
                        .padding(8)
                        .background(.black.opacity(0.32), in: Capsule())
                        .padding(10)
                }
                .overlay(alignment: .bottomLeading) {
                    ProgressView(value: showProgress ? item.progress : 0, total: 1)
                        .tint(.white)
                        .padding(10)
                        .animation(.easeOut(duration: 1), value: showProgress)
                }

            Text(item.title)
                .font(.headline)
                .lineLimit(1)

            Text(item.nextStep)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
        }
        .frame(width: 180)
        .onAppear {
            showProgress = true
        }
    }
}

private struct TimelineRow: View {
    let entry: MemoryEntry

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Circle()
                .fill(entry.tint)
                .frame(width: 12, height: 12)
                .padding(.top, 8)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(entry.title)
                        .font(.headline)
                    Spacer()
                    Text(entry.timestamp, format: .dateTime.hour().minute())
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.65))
                }

                Text(entry.summary)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))

                Text(entry.tags.joined(separator: " • "))
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))
            }
            .padding(12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

private struct AddMemoryButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.title.bold())
                .foregroundStyle(.black)
                .frame(width: 58, height: 58)
                .background(Color.white, in: Circle())
                .shadow(color: .white.opacity(0.5), radius: 10)
        }
    }
}

private struct AnimatedBackdropView: View {
    @State private var shift = false

    var body: some View {
        LinearGradient(
            colors: [.black, Color(red: 0.12, green: 0.05, blue: 0.2), Color(red: 0.05, green: 0.15, blue: 0.25)],
            startPoint: shift ? .topLeading : .bottomTrailing,
            endPoint: shift ? .bottomTrailing : .topLeading
        )
        .ignoresSafeArea()
        .overlay {
            Circle()
                .fill(.pink.opacity(0.25))
                .blur(radius: 80)
                .frame(width: 220)
                .offset(x: shift ? -120 : 120, y: shift ? -260 : -180)
        }
        .overlay {
            Circle()
                .fill(.cyan.opacity(0.22))
                .blur(radius: 90)
                .frame(width: 260)
                .offset(x: shift ? 130 : -130, y: shift ? 260 : 180)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                shift.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MemoryFeedViewModel())
}
