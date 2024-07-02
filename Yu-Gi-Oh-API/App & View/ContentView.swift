///
/// API Guide
/// https://ygoprodeck.com/api-guide/
///
/// Dark Magician
/// https://db.ygoprodeck.com/api/v7/cardinfo.php?name=Dark%20Magician

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            ListView()
                .tabItem { Label("List", systemImage: "list.bullet") }
            SettingView()
                .tabItem { Label("Setting", systemImage: "gearshape") }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: YDMCard.self, inMemory: true)
        .preferredColorScheme(.dark)
}

//struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var cards: [Card]
//
//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(cards) { card in
//                    NavigationLink(card.name) {
//                       CardDetailView(card)
//                    }
//                }
//                .onDelete(perform: deleteCards)
//            }
//            .navigationTitle("Yu-Gi-Oh")
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    EditButton()
//                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button(action: addCard) {
//                        Label("Add Card", systemImage: "plus")
//                    }
//                }
//            }
//            .animation(.easeIn, value: cards)
//        } detail: {
//            Text("Select an card")
//        }
//    }
//
//    private func addCard() {
//        Task {
//            guard let card = await APIClient().fetch() else { return }
//            modelContext.insert(card)
//        }
//    }
//
//    private func deleteCards(offsets: IndexSet) {
//        for index in offsets {
//            modelContext.delete(cards[index])
//        }
//    }
//}
