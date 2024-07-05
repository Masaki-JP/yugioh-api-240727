import SwiftUI

struct HomeViewContentBody: View {
    @StateObject private var scrollObserver = ScrollObserver()

    var body: some View {
        ScrollView {
            LazyVStack {
                ScrollableCardRow("New Cards", lines: 2)
                ScrollableCardRow("Favorite Cards", lines: 2)
                ScrollableCardRow("Random Cards", lines: 2)
                ScrollableCardRow("All Cards", lines: 2)
                ScrollableCardRow("XXX Cards", lines: 3)
                ScrollableCardRow("XXX Cards", lines: 3)
                ScrollableCardRow("XXX Cards", lines: 3)
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
