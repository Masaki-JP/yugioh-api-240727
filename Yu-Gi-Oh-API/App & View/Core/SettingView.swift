import SwiftUI
import SwiftData

struct SettingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var cards: [YDMCard]
    @State private var isShowingAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Button("データの全削除", role: .destructive) {
                    isShowingAlert = true
                }
                .disabled(cards.isEmpty)
            }
            .alert("確認", isPresented: $isShowingAlert) {
                Button("削除する", role: .destructive) {
                    try! modelContext.delete(model: YDMCard.self) // ⚠️
                }
            } message: {
                Text("全てのデータを削除しますか？")
            }
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}

#Preview {
    SettingView()
        .preferredColorScheme(.dark)
}
