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
                            NavigationLink {
                                CardDetailView(card)
                            } label: {
                                Image(uiImage: uiImage)
                                    .resizable().scaledToFit()
                            }
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

#Preview("Normal Case") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: YDMCard.self, configurations: config)

    let uiImage = UIImage(named: "Dark_Magician")!
    let imageData = uiImage.jpegData(compressionQuality: 1.0)!

    for _ in 0..<10 {
        let card = YDMCard(name: "Dark Magician", data: imageData)
        container.mainContext.insert(card)
    }

    return CardListView()
        .preferredColorScheme(.dark)
        .modelContainer(container)
}

#Preview("Empty Case") {
    CardListView()
        .preferredColorScheme(.dark)
        .modelContainer(for: YDMCard.self, inMemory: true)
}
