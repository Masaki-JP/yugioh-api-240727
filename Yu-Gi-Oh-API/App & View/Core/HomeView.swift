import SwiftUI
import SwiftData
import Pow

@MainActor
struct HomeView: View {
    @Query private var cards: [YDMCard]
    @State private var isScrolling = false
    @State private var cardsForGetCardView: CardPack?
    @State private var asynchronousTask: Task<Void, Never>?
    @State private var isFetching = false
    @Namespace private var namespace
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            HomeViewContent {
                if cards.isEmpty == false {
                    HomeViewContentBody(cards: cards)
                        .safeAreaInset(edge: .bottom) {
                            HStack(spacing: 0) {
                                if isScrolling { Spacer() }
                                getCardsButton.padding(.trailing, isScrolling ? 15 : 0)
                            }
                            .padding(.bottom, 10)
                        }
                } else {
                    VStack(spacing: .zero) {
                        grayOutCards
                        getSpecialCardsButton
                    }
                }
            }
            .navigationDestination(for: YDMCard.self) {
                CardDetailView($0)
            }
            .navigationDestination(for: NavigationDestinationData.self) {
                cardList($0.cards)
                    .navigationTitle($0.title)
            }
        }
        .onPreferenceChange(IsScrollingPreferenceKey.self) { value in
            isScrolling = value
        }
        .animation(.easeInOut(duration: 0.1), value: isScrolling)
        .fullScreenCover(
            item: $cardsForGetCardView,
            onDismiss: { asynchronousTask = nil },
            content: { GetCardView(availableCards: $0.value) }
        )
        .onDisappear {
            asynchronousTask?.cancel()
            isFetching = false
        }
        .onChange(of: scenePhase) {
            asynchronousTask?.cancel()
            isFetching = false
        }
        .preference(key: IsFetchingPreferenceKey.self, value: isFetching)
    }

    var getCardsButton: some View {
        Button(action: didTapGetCardsButton) {
            if isScrolling == false {
                Text("Let's get new card!!")
                    .font(.title2)
                    .lineLimit(1)
                    .fontWeight(.semibold)
                    .frame(height: 40) // TotalHeight: 40
                    .padding(.horizontal, 50)
                    .foregroundStyle(.white)
                    .background(.orange.gradient)
                    .clipShape(.capsule)
                    .matchedGeometryEffect(id: "getCardsButton", in: namespace)
            } else {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 20)
                    .padding(10) // TotalHeight: 50
                    .background(.orange.gradient)
                    .clipShape(.circle)
                    .matchedGeometryEffect(id: "getCardsButton", in: namespace)
            }
        }
    }

    // @Stateが付与された値の変更なので、メインスレッドで書き込みを行う必要はない。
    func didTapGetCardsButton() {
        guard isFetching == false else { return }
        isFetching = true
        asynchronousTask = .init {
            guard let cardDTOs = await YuGiOhAPIClient().fetchCards(5)
            else { return }
            let cards = cardDTOs.map(YDMCard.convert)
            cardsForGetCardView = .some(.init(value: cards))
            isFetching = false
        }
    }

    func cardList(_ cards: [YDMCard]) -> some View {
        List(cards) { card in
            NavigationLink(value: card) {
                HStack {
                    Image(uiImage: .init(data: card.imageData.small)!) // ⚠️
                        .resizable().scaledToFit()
                        .frame(height: 75)
                    VStack(alignment: .leading) {
                        Text(card.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.bottom, 3)
                        Group {
                            Text("card.isFavorite: " + card.isFavorite.description)
                            Text("card.acquisitionDate: ")
                            + Text(card.acquisitionDate, style: .date)
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.leading, 5)
                }
            }
        }
    }

    var grayOutCards: some View {
        let resources: [ImageResource] = [.blueEyesWhiteDragonSmall, .mirrorForceSmall, .jinzoSmall, .relinquishedSmall, .polymerizationSmall, .darkMagicianSmall, .destinyBoardSmall, .xyzDragonCannonSmall, .monsterRebornSmall]

       return VStack(spacing: 20) {
            HStack(spacing: 10) {
                ForEach(resources[0..<5], id: \.self) { resource in
                    Image(resource)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .rotationEffect(.degrees(10.0))
                }
            }
            HStack(spacing: 10) {
                ForEach(resources[5..<9], id: \.self) { resource in
                    Image(resource)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .rotationEffect(.degrees(10.0))
                }
            }
            .offset(y: -30.0)
        }
        .grayscale(1.0)
    }

    var getSpecialCardsButton: some View {
        Button {
            guard isFetching == false else { return }
            isFetching = true
            asynchronousTask = .init {
                guard let cardDTOs = await YuGiOhAPIClient().fetchSpecialCards()
                else { return }
                let cards = cardDTOs.map(YDMCard.convert)
                cardsForGetCardView = .some(.init(value: cards))
                isFetching = false
            }
        } label: {
            Text("Let's get special cards!!")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 20)
                .background(.orange)
                .clipShape(.capsule)
        }
    }
}

private struct CardPack: Identifiable {
    let id = UUID()
    let value: [YDMCard]
}

extension HomeView {
    struct NavigationDestinationData: Hashable {
        let title: String
        let cards: [YDMCard]

        init(_ title: String, _ cards: [YDMCard]) {
            self.title = title
            self.cards = cards
        }
    }
}

#Preview("Normal Case") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: YDMCard.self, configurations: config)
    YDMCard.samples(10).forEach { container.mainContext.insert($0) }

    return HomeView()
        .modelContainer(container)
        .preferredColorScheme(.dark)
}

#Preview("Empty Case") {
    HomeView()
        .modelContainer(for: YDMCard.self, inMemory: true)
        .preferredColorScheme(.dark)
}
