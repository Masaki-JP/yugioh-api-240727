import SwiftUI

struct VerticalOffsetPreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
