import SwiftUI

struct IsFetchingPreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {}
}
