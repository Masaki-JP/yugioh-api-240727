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
///
/// struct ParentView: View {
///     @State private var isScroling = false
///     private let lightGray = Color(red: 0.6, green: 0.6, blue: 0.6)
///     private let darkGray = Color(red: 0.4, green: 0.4, blue: 0.4)
///
///     var body: some View {
///         ChildView()
///             .background(isScroling ? darkGray : lightGray, in: .rect)
///             .ignoresSafeArea()
///             .onPreferenceChange(IsScrollingPreferenceKey.self) { value in
///                 isScroling = value
///             }
///     }
/// }
/// ```
struct IsScrollingPreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {}
}
