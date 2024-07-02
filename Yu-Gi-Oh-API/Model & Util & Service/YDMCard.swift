import Foundation
import SwiftData

@Model
final class YDMCard { // Yu-Gi-Oh Duel Monsters
    let name: String
    let imageData: Data
    var isFavorite: Bool
    let acquisitionDate: Date

    init(name: String, data: Data, isFavorite: Bool = false) {
        self.name = name
        self.imageData = data
        self.isFavorite = isFavorite
        self.acquisitionDate = .init()
    }
}
