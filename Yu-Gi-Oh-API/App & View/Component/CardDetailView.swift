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

#Preview {
    let uiImage = UIImage(named: "Dark_Magician")!
    let imageData = uiImage.jpegData(compressionQuality: 1.0)!
    let card = YDMCard(name: "Dark Magician", data: imageData)
    return CardDetailView(card)
}
