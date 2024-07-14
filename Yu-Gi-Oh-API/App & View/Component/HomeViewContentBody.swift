import SwiftUI

struct HomeViewContentBody: View {
    @StateObject private var scrollObserver = ScrollObserver()
    @State private var sampleCards = getSampleCards(50)

    var body: some View {
        ScrollView {
            LazyVStack {
                ScrollableCardRow("New Cards", cards: .init(sampleCards[0..<10]))
                ScrollableCardRow("Favorite Cards", cards: .init(sampleCards[0..<10]))
                ScrollableCardRow("Random Cards", cards: .init(sampleCards[0..<20]))
                ScrollableCardRow("All Cards", cards: .init(sampleCards[0..<20]))
                ScrollableCardRow("XXX Cards", cards: .init(sampleCards[0..<20]))
                ScrollableCardRow("XXX Cards", cards: .init(sampleCards[0..<40]))
                ScrollableCardRow("XXX Cards", cards: .init(sampleCards[0..<50]))
            }
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .onChange(of: geometry.frame(in: .global)) { _, _ in
                            scrollObserver.run()
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
        .preference(
            key: IsScrollingPreferenceKey.self,
            value: scrollObserver.isScrolling
        )
    }
}

#Preview {
    HomeViewContentBody()
}
