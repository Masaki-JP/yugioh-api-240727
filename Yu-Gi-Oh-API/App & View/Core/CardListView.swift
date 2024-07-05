import SwiftUI
import SwiftData

struct CardListView: View {
    @Query private var cards: [YDMCard]
    private let columns = [GridItem(.adaptive(minimum: 70, maximum: 100))]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(cards) { card in
                        if let uiImage = UIImage(data: card.imageData) {
                            Image(uiImage: uiImage)
                                .resizable().scaledToFit()
                        } else {
                            Text("Error")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("All Cards")
            .toolbarTitleDisplayMode(.inlineLarge)
            .overlay {
                if cards .isEmpty {
                    ContentUnavailableView("No Cards", systemImage: "tray.fill", description: Text("You can get new cards from Home."))
                }
            }
        }
    }
}

#Preview {
    CardListView()
        .preferredColorScheme(.dark)
}
