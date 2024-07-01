import SwiftUI

struct HomeView: View {
    var body: some View {
        HomeViewContent {
            ScrollView {
                LazyVStack {
                    ScrollableCardRow("New Cards", lines: 2)
                    ScrollableCardRow("Favorite Cards", lines: 2)
                    ScrollableCardRow("All Cards", lines: 2)
                }
            }
            .safeAreaInset(edge: .bottom) {
                getCardsButton
                    .padding(.bottom)
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
        .preferredColorScheme(.dark)
}
