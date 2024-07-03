import SwiftUI
import Pow

struct GetCardView: View {
    @Environment(\.dismiss) private var dismiss
    private let availableCard: Int

    init(availableCard: Int = 3) {
        self.availableCard = availableCard
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(0..<availableCard, id: \.self) { i in
                    VStack {
                        SeacretCard()
                        if i != availableCard - 1 {
                            Text("Swipe up to next card")
                                .font(.title3)
                                .fontWeight(.semibold)
                        } else {
                            Button("Back to home", action: dismiss.callAsFunction)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.horizontal)
                    .containerRelativeFrame(.vertical)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
    }
}

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
    GetCardView()
        .preferredColorScheme(.dark)
}
