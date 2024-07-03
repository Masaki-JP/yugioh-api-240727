import SwiftUI

struct SeacretCard: View {
    @State private var isCovering = true

    var body: some View {
        Image(.darkMagician)
            .resizable()
            .scaledToFit()
            .overlay {
                if isCovering == true {
                    cardCover
                        .transition(.movingParts.glare)
                        .onTapGesture {
                            withAnimation {
                                isCovering = false
                            }
                        }
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
}

#Preview {
    SeacretCard()
        .preferredColorScheme(.dark)
}
