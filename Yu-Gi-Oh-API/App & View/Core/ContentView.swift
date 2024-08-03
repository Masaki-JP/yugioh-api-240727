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
