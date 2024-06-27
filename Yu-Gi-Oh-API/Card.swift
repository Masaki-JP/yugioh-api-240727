import Foundation
import SwiftData

@Model
final class Card {
    let name: String
    let data: Data

    init(name: String, data: Data) {
        self.name = name
        self.data = data
    }
}
