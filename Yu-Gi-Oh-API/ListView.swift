import SwiftUI

struct ListView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [.init(.adaptive(minimum: 70, maximum: 100))]) {
                    ForEach(0..<30) { _ in
                        Image(.darkMagician)
                            .resizable().scaledToFit()
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("All Cards")
        }
    }
}

#Preview {
    ListView()
}
