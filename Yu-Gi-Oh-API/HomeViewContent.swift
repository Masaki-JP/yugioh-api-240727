import SwiftUI

/// ⚠️ ExpandingWidth & ExpandingHeight
struct HomeViewContent<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            header
            VStack {
                content()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal, 5)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var header: some View {
        HStack {
            Image(systemName: "line.3.horizontal")
                .resizable()
                .frame(width: 30, height: 20)
            Spacer()
            Image(.yuGiOh)
                .resizable().scaledToFit()
                .frame(height: 50)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            Spacer()
            Image(systemName: "magnifyingglass")
                .resizable().scaledToFit()
                .frame(width: 30)
        }
    }
}

#Preview {
    HomeViewContent {
        Text("Hello, world.")
    }
    .preferredColorScheme(.dark)
}
