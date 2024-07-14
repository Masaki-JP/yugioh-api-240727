import SwiftUI

struct HomeView: View {
    @State private var isScrolling = false
    @State private var cardsForGetCardView: CardPack?
    @State private var asynchronousTask: Task<Void, Never>?
    @State private var isFetching = false
    @Namespace private var namespace
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            HomeViewContent {
                HomeViewContentBody()
                    .safeAreaInset(edge: .bottom) {
                        HStack(spacing: 0) {
                            if isScrolling { Spacer() }
                            getCardsButton.padding(.trailing, isScrolling ? 15 : 0)
                        }
                        .padding(.bottom, 10)
                    }
            }
            .navigationDestination(for: YDMCard.self) {
                CardDetailView($0)
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
            guard let cards = await YuGiOhAPIClient().fetch(numberOfCards: 3)
            else { return }
            cardsForGetCardView = .some(.init(value: cards))
            isFetching = false
        }
    }
}

private struct CardPack: Identifiable {
    let id = UUID()
    let value: [YDMCard]
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
