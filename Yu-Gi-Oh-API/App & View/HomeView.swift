import SwiftUI

struct HomeView: View {
    @State private var isScrolling = false
    @Namespace private var namespace

    var body: some View {
        HomeViewContent {
            HomeViewContentBody()
                .safeAreaInset(edge: .bottom) {
                    HStack(spacing: 0) {
                        if isScrolling { Spacer() }
                        getCardsButton.padding(.trailing, isScrolling ? 15 : 0)
                    }
                    .padding(.bottom, 10)
                }
                .onPreferenceChange(IsScrollingPreferenceKey.self) { value in
                    isScrolling = value
                }
                .animation(.easeInOut(duration: 0.1), value: isScrolling)
        }
    }

    var getCardsButton: some View {
        Button {} label: {
            if isScrolling == false {
                Text("Let's get new card!!")
                    .font(.title2)
                    .lineLimit(1)
                    .fontWeight(.semibold)
                    .frame(height: 40) // TotalHeight: 40
                    .padding(.horizontal, 50)
                    .foregroundStyle(.white)
                    .background(.orange.gradient)
                    .clipShape(.capsule)
                    .matchedGeometryEffect(id: "getCardsButton", in: namespace)
            } else {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 20)
                    .padding(10) // TotalHeight: 50
                    .background(.orange.gradient)
                    .clipShape(.circle)
                    .matchedGeometryEffect(id: "getCardsButton", in: namespace)
            }
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
