import SwiftUI

struct HomeViewContentBody: View {
    @StateObject private var scrollObserver = ScrollObserver()

    var body: some View {
        ScrollView {
            LazyVStack {
                ScrollableCardRow("New Cards", cards: getSampleCards(10))
                ScrollableCardRow("Favorite Cards", cards: getSampleCards(10))
                ScrollableCardRow("Random Cards", cards: getSampleCards(20))
                ScrollableCardRow("All Cards", cards: getSampleCards(20))
                ScrollableCardRow("XXX Cards", cards: getSampleCards(30))
                ScrollableCardRow("XXX Cards", cards: getSampleCards(40))
                ScrollableCardRow("XXX Cards", cards: getSampleCards(50))
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
