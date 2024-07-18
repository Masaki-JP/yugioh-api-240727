import SwiftUI
import SwiftData

struct HomeViewContentBody: View {
    @StateObject private var scrollObserver = ScrollObserver()
    let cards: [YDMCard]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ScrollableCardRow(
                    "Favorite Cards",
                    cards: cards,
                    filter: \.isFavorite
                )
                ScrollableCardRow(
                    "New Cards",
                    cards: cards,
                    sort: { $0.acquisitionDate > $1.acquisitionDate }
                )
                ScrollableCardRow("All Cards", cards: cards)
                    .padding(.bottom, 15)
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
    HomeViewContentBody(cards: YDMCard.samples(50))
}
