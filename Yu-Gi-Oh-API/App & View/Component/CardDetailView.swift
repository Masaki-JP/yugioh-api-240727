import SwiftUI

struct CardDetailView: View {
    private let card: YDMCard

    init(_ card: YDMCard) {
        self.card = card
    }

    var body: some View {
        Group {
            if let uiImage = UIImage(data: card.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
            } else {
                Text("Error")
            }
        }
        .navigationTitle(card.name)
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.increase, trigger: card.isFavorite)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    card.isFavorite.toggle()
                } label: {
                    Label("Favorite", systemImage: card.isFavorite ? "star.fill" : "star")
                }
            }
        }
    }
}

#Preview {
    let uiImage = UIImage(named: "Dark_Magician")!
    let imageData = uiImage.jpegData(compressionQuality: 1.0)!
    let card = YDMCard(name: "Dark Magician", data: imageData)

    return NavigationStack {
        CardDetailView(card)
    }
}
