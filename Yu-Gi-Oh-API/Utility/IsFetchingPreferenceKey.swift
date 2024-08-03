import SwiftUI

/// スクロール中か否かを親ビューに伝えるために用いるプリファレンスキー。
struct IsFetchingPreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {}
}
