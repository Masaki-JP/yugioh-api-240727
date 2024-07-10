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
                        .preference(
                            key: VerticalOffsetPreferenceKey.self,
                            value: geometry.frame(in: .global).minY
                        )
                }
            }
        }
        .scrollIndicators(.hidden)
        .onPreferenceChange(VerticalOffsetPreferenceKey.self) { _ in
            scrollObserver.run()
        }
        .preference(
            key: IsScrollingPreferenceKey.self,
            value: scrollObserver.isScrolling
        )
    }
}

#Preview {
    HomeViewContentBody()
}
