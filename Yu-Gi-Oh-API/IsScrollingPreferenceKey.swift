import SwiftUI

struct IsScrollingPreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {}
}
