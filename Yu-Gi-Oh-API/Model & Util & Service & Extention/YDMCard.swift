import UIKit
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

    static func convert(dto: DTO) -> YDMCard {
        .init(
            name: dto.name,
            normalSizeImageData: dto.imageData.normal,
            smallSizeImageData: dto.imageData.small,
            isFavorite: dto.isFavorite
        )
    }
}

extension YDMCard {
    struct DTO: Decodable {
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
    }
}

extension YDMCard {
    static func sample() -> YDMCard {
        let uiImage_normal = UIImage(named: "Dark_Magician_Normal")!
        let uiImage_small = UIImage(named: "Dark_Magician_Small")!
        let normalSizeImageData = uiImage_normal.jpegData(compressionQuality: 0.0)!
        let smallSizeImageData = uiImage_small.jpegData(compressionQuality: 0.0)!

        return .init(
            name: "Dark Magician",
            normalSizeImageData: normalSizeImageData,
            smallSizeImageData: smallSizeImageData
        )
    }

    static func samples(_ numberOfCard: Int) -> [YDMCard] {
        let uiImage_normal = UIImage(named: "Dark_Magician_Normal")!
        let uiImage_small = UIImage(named: "Dark_Magician_Small")!
        let normalSizeImageData = uiImage_normal.jpegData(compressionQuality: 0.0)!
        let smallSizeImageData = uiImage_small.jpegData(compressionQuality: 0.0)!

        return (0..<numberOfCard).map { _ in
                .init(
                    name: "Dark Magician",
                    normalSizeImageData: normalSizeImageData,
                    smallSizeImageData: smallSizeImageData
                )
        }
    }
}
