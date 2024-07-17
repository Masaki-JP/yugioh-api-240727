///
/// API Guide
/// https://ygoprodeck.com/api-guide/
///
/// Dark Magician
/// https://db.ygoprodeck.com/api/v7/cardinfo.php?name=Dark%20Magician

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            CardListView()
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
