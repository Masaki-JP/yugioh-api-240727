import SwiftUI

/// ⚠️ ExpandingWidth
struct ScrollableCardRow: View {
    private let title: String
    private let cards: [YDMCard]
    private let numberOfColumns: Int
    private let targetRange: Range<Int>
    private let targetCards: [YDMCard]
    private let lazyVStackHeight: CGFloat

    init?(_ title: String, cards: [YDMCard]) {
        guard cards.isEmpty == false else { return nil }

        self.title = title
        self.cards = cards

        self.numberOfColumns = switch cards.count {
        case 1...20: 1; case 21...40: 2; case 41...: 3; default: 0;
        }

        self.targetRange = 0..<Swift.min(cards.count, numberOfColumns * 20)
        self.targetCards = Array(cards[targetRange])
        self.lazyVStackHeight = .init(110 * numberOfColumns - 10)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    Button("more") {}
                }
                .padding(.horizontal, 5) // ※ 1
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(targetCards.chuncked(numberOfColumns), id: \.self) { chunk in
                            VStack(spacing: 10) {
                                ForEach(chunk.reversed(), id: \.self) { card in
                                    NavigationLink(value: card) {
                                        Image(uiImage: .init(data: card.imageData.small)!)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                            .frame(
                                                maxHeight: chunk.last == .some(card) ? .infinity : nil,
                                                alignment: .top
                                            )
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: lazyVStackHeight) // Disable ExpandingHeight
                    .padding(.horizontal, 5) // ※1
                }
                .padding(.top, 5)
            }
    }
}

#Preview {
    return ScrollView {
        ScrollableCardRow("Favorites", cards: getSampleCards(20))

        ScrollableCardRow("Favorites", cards: getSampleCards(39))
        ScrollableCardRow("Favorites", cards: getSampleCards(40))

        ScrollableCardRow("Favorites", cards: getSampleCards(58))
        ScrollableCardRow("Favorites", cards: getSampleCards(59))
        ScrollableCardRow("Favorites", cards: getSampleCards(60))
    }
    .preferredColorScheme(.dark)
}
