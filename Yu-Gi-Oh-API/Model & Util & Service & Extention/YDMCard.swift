import Foundation
import SwiftData

@Model
final class YDMCard { // Yu-Gi-Oh Duel Monsters
    let name: String
    let imageData: ImageData
    var isFavorite: Bool
    let acquisitionDate: Date

    init(name: String, normalSizeImageData: Data, smallSizeImageData: Data, isFavorite: Bool = false) {
        self.name = name
        self.imageData = .init(normal: normalSizeImageData, small: smallSizeImageData)
        self.isFavorite = isFavorite
        self.acquisitionDate = .init()
    }

    struct ImageData: Codable {
        let normal, small: Data
    }
}
