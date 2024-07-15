import SwiftUI
import SwiftData

struct HomeViewContentBody: View {
    @StateObject private var scrollObserver = ScrollObserver()
    let cards: [YDMCard]

    var body: some View {
        ScrollView {
            LazyVStack {
                ScrollableCardRow("New Cards", cards: cards)
                ScrollableCardRow("Favorite Cards", cards: cards)
                ScrollableCardRow("Random Cards", cards: cards)
                ScrollableCardRow("All Cards", cards: cards)
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
    HomeViewContentBody(cards: getSampleCards(50))
}
