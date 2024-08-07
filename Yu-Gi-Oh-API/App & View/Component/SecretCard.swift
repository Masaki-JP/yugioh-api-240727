import SwiftUI
import AVFoundation
import SwiftData

struct SecretCard: View {
    @State private var isCovering = true
    private let card: YDMCard
    private let invalidateSoundEffect: Bool
    private let audioPlayer: AVAudioPlayer?
    @Environment(\.modelContext) private var modelContext

    init(_ card: YDMCard, invalidateSoundEffect: Bool = false) {
        self.card = card
        self.invalidateSoundEffect = invalidateSoundEffect

        if let dataAsset = NSDataAsset(name: "CardFlip"),
           let audioPlayer = try? AVAudioPlayer(data: dataAsset.data) {
            self.audioPlayer = audioPlayer
        } else {
            self.audioPlayer = nil
        }
    }

    var body: some View {
        if let uiImage = UIImage(data: card.imageData.normal) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .overlay {
                    if isCovering == true {
                        cardCover
                            .transition(.movingParts.glare)
                            .onTapGesture(perform: openCard)
                    }
                }
                .sensoryFeedback(.impact, trigger: isCovering)
        } else {
            Text("Error")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    var cardCover: some View {
        GeometryReader {
            Image(systemName: "questionmark")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: $0.size.width*0.3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
    }

    func openCard() {
        guard isCovering == true else { return }
        withAnimation {
            modelContext.insert(card)
            isCovering = false
            if invalidateSoundEffect == false {
                audioPlayer?.play()
            }
        }
    }
}

#Preview {
    SecretCard(YDMCard.sample())
        .modelContainer(for: YDMCard.self, inMemory: true)
}
