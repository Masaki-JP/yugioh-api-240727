import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationStack {
            Text("Coming soon...")
                .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingView()
        .preferredColorScheme(.dark)
}
