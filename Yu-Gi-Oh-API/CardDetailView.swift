import SwiftUI

struct CardDetailView: View {
    private let card: Card

    init(_ card: Card) {
        self.card = card
    }

    var body: some View {
        if let uiImage = UIImage(data: card.data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .padding()
        } else {
            Text("Error")
        }
    }
}
