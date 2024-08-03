import SwiftUI

/// スクロール中か否かを親ビューに伝えるために用いるプリファレンスキー。
///
/// 以下のように``ScrollObserver``と``IsScrollingPreferenceKey``
/// と一緒に使用する。
///
/// ```swift
/// struct ChildView: View {
///     @StateObject private var scrollObserver = ScrollObserver()
///
///     var body: some View {
///         ScrollView {
///             LazyVStack {
///                 ForEach(0..<50) { _ in
///                     Text("Hello, world.")
///                 }
///             }
///             .background {
///                 GeometryReader { geometry in
///                     Color.clear
///                         .preference(
///                             key: VerticalOffsetPreferenceKey.self,
///                             value: geometry.frame(in: .global).minY
///                         )
///                 }
///             }
///         }
///         .onPreferenceChange(VerticalOffsetPreferenceKey.self) { _ in
///             scrollObserver.run()
///         }
///         .preference(
///             key: IsScrollingPreferenceKey.self,
///             value: scrollObserver.isScrolling
///         )
///     }
/// }
/// ```
struct VerticalOffsetPreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
