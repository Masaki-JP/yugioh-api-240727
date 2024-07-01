import SwiftUI

struct HomeView: View {
    var body: some View {
        HomeViewContent {
            VStack {
                Spacer()
                ScrollableCardRow("New Cards", lines: 2)
                ScrollableCardRow("Favorite Cards", lines: 2)
                Spacer()
                getCardsButton
                Text("(You can get 15 cards.)")
                    .font(.callout)
                    .padding(.bottom, 10)
            }
        }
    }

    var getCardsButton: some View {
        Button(action: {}, label: {
            Text("Let's get new card!!")
                .fontWeight(.semibold)
                .frame(height: 30)
                .padding(.horizontal, 50)
                .foregroundStyle(.white)
                .background(Color.orange.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        })
    }
}

#Preview {
    HomeView()
}
