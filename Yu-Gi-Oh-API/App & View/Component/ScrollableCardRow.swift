import SwiftUI

/// ⚠️ ExpandingWidth
struct ScrollableCardRow: View {
    private let title: String
    private let cards: [YDMCard]
    private let numberOfColumns: Int
    private let targetRange: Range<Int>
    private let targetCards: [YDMCard]
    private let lazyVStackHeight: CGFloat

    init(_ title: String, cards: [YDMCard]) {
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
        if cards.isEmpty == false {
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
                                ForEach(chunk, id: \.self) { card in
                                    let maxHeight: CGFloat? = chunk.last == .some(card) ? .infinity : nil

                                    Image(uiImage: .init(data: chunk[0].imageData)!)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .frame(maxHeight: maxHeight, alignment: .top)
                                }
                            }
                        }
                    }
                    .frame(height: lazyVStackHeight) // Disable ExpandingHeight
                    .padding(.horizontal, 5) // ※1
                }
                .padding(.top, 5)
            }
        } else {
            EmptyView()
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
