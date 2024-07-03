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

#Preview {
    GetCardView()
        .preferredColorScheme(.dark)
}
