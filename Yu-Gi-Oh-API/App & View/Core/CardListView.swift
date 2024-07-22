import SwiftUI
import SwiftData

struct CardListView: View {
    @Query private var cards: [YDMCard]
    @Environment(\.modelContext) private var modelContext
    @State private var isEditing = false
    @State private var selectedCards: Set<YDMCard> = .init()
    private let columns = [GridItem(.adaptive(minimum: 70, maximum: 100))]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(cards) { card in
                        if let uiImage = UIImage(data: card.imageData.small) {
                            NavigationLink {
                                CardDetailView(card)
                            } label: {
                                Image(uiImage: uiImage)
                                    .resizable().scaledToFit()
                            }
                            .disabled(isEditing == true)
                            .overlay {
                                if isEditing == true, selectedCards.contains(card) {
                                    selectedItemCover
                                }
                            }
                            .onTapGesture {
                                guard isEditing == true else { return }
                                if selectedCards.contains(card) == false {
                                    selectedCards.insert(card)
                                } else {
                                    selectedCards.remove(card)
                                }
                            }
                        } else {
                            Text("Error")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .scrollDisabled(cards.isEmpty == true)
            .overlay {
                if cards .isEmpty {
                    ContentUnavailableView("No Cards", systemImage: "tray.fill", description: Text("You can get new cards from Home."))
                }
            }
            .navigationTitle("All Cards")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar(content: toolbarContent)
            .sensoryFeedback(.impact, trigger: isEditing)
            .sensoryFeedback(.decrease, trigger: selectedCards)
        }
    }

    var selectedItemCover: some View {
        GeometryReader {
            Color.black.opacity(0.3)
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: $0.size.width * 0.3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.green)
        }
    }

    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            if isEditing {
                Button("Delete", role: .destructive) {
                    withAnimation {
                        selectedCards.forEach {
                            modelContext.delete($0)
                        }
                        selectedCards.removeAll()
                        isEditing = false
                    }
                }
                .tint(.red)
                .disabled(selectedCards.isEmpty == true)
            }
            Button(isEditing == false ? "Edit" : "Done") {
                if isEditing == true {
                    selectedCards.removeAll()
                }
                isEditing.toggle()
            }
        }
    }
}

#Preview("Normal Case") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: YDMCard.self, configurations: config)
    YDMCard.samples(10).forEach { container.mainContext.insert($0) }

    return CardListView()
        .modelContainer(container)
        .preferredColorScheme(.dark)
}

#Preview("Empty Case") {
    CardListView()
        .modelContainer(for: YDMCard.self, inMemory: true)
        .preferredColorScheme(.dark)
}
