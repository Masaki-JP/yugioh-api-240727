import SwiftUI

/// ⚠️ ExpandingWidth
struct ScrollableCardRow: View {
    let title: String
    let lines: Int

    init(_ title: String, lines: Int? = nil) {
        if let lines, lines < 0 { fatalError() }
        self.title = title
        self.lines = lines ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button("more") {}
            }
            .padding(.horizontal, 5) // ※ 1
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(0..<30) { _ in
                        VStack {
                            ForEach(0..<(lines), id: \.self) { _ in
                                Image(.darkMagician).resizable().scaledToFit()
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }
                .frame(height: 100 * .init((lines))) // Disable ExpandingHeight
                .padding(.horizontal, 5) // ※1
            }
            .padding(.top, 5)
        }
    }
}

#Preview {
    //    ScrollableCardRow("Favorites")
    ScrollableCardRow("Favorites", lines: 2)
        .preferredColorScheme(.dark)
}
