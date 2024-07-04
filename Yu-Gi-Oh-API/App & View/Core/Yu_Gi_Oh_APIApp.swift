import SwiftUI
import SwiftData

@main
struct Yu_Gi_Oh_APIApp: App {
    @State private var isFetching = false

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            YDMCard.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
                .preferredColorScheme(.dark)
                .overlay {
                    if isFetching == true {
                        Color.black.opacity(0.5).ignoresSafeArea()
                        ProgressView()
                            .scaleEffect(3.0)
                    }
                }
                .disabled(isFetching == true)
                .onPreferenceChange(IsFetchingPreferenceKey.self) { value in
                    isFetching = value
                }
                .animation(.easeIn, value: isFetching)
        }
    }
}
