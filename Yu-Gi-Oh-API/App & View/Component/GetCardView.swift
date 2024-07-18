import SwiftUI
import Pow

struct GetCardView: View {
    @Environment(\.dismiss) private var dismiss
    let availableCards: [YDMCard]

    var body: some View {
        if availableCards.isEmpty == false {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(availableCards) { card in
                        VStack {
                            SecretCard(card)
                                .frame(maxWidth: 400)
                            if card !== availableCards.last! { // ⚠️ Force Unwrap
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
        } else {
            Text("Error")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    return GetCardView(availableCards: YDMCard.samples(3))
}