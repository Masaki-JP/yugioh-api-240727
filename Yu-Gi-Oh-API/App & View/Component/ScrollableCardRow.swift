import SwiftUI

/// ⚠️ ExpandingWidth
struct ScrollableCardRow: View {
    private let title: String
    private let cards: [YDMCard]
    private let sort: ((YDMCard, YDMCard) -> Bool)?
    private let filter: ((YDMCard) -> Bool)?

    init(
        _ title: String,
        cards: [YDMCard],
        sort: ((YDMCard, YDMCard) -> Bool)? = nil,
        filter: ((YDMCard) -> Bool)? = nil
    ) {
        self.title = title
        self.cards = cards
        self.sort = sort
        self.filter = filter
    }

    var body: some View {
        let cards = {
            let sortedCards = if let sort { self.cards.sorted(by: sort) } else { self.cards }
            let filteredCards = if let filter { sortedCards.filter(filter) } else { sortedCards }
            return filteredCards
        }()

        let numberOfColumns = if UIDevice.current.userInterfaceIdiom == .phone {
            switch cards.count {
            case 1...20: 1; case 21...: 2; default: 0;
            }
        } else {
            switch cards.count {
            case 1...20: 1; case 21...40: 2; case 41...: 3; default: 0;
            }
        }

        let targetRange = 0..<Swift.min(cards.count, numberOfColumns * 20)
        let targetCards = Array(cards[targetRange])
        let lazyVStackHeight = CGFloat(110 * numberOfColumns - 10)

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
