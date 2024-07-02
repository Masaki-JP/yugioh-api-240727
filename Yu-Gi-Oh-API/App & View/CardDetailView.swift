import SwiftUI

struct CardDetailView: View {
    private let card: YDMCard

    init(_ card: YDMCard) {
        self.card = card
    }

    var body: some View {
        if let uiImage = UIImage(data: card.imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .padding()
        } else {
            Text("Error")
        }
    }
}
