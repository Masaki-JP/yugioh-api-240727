import SwiftUI
import AVFoundation

struct SecretCard: View {
    @State private var isCovering = true
    let invalidateSoundEffect: Bool
    let audioPlayer: AVAudioPlayer?

    init(invalidateSoundEffect: Bool = false) {
        self.invalidateSoundEffect = invalidateSoundEffect
        if let dataAsset = NSDataAsset(name: "CardFlip"),
           let audioPlayer = try? AVAudioPlayer(data: dataAsset.data) {
            self.audioPlayer = audioPlayer
        } else {
            self.audioPlayer = nil
        }
    }

    var body: some View {
        Image(.darkMagician)
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
        withAnimation {
            isCovering = false
            if invalidateSoundEffect == false {
                audioPlayer?.play()
            }
        }
    }
}

#Preview {
    SecretCard()
        .preferredColorScheme(.dark)
}
