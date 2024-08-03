import UIKit
import SwiftData

/// 遊戯王カードを表現するエンティティ。Yu-Gi-Oh Duel Monsters Cardを略して``YDMCard``としている。
@Model final class YDMCard {
    /// カード名を表すプロパティ。
    let name: String
    /// 画像データを表すプロパティ。
    let imageData: ImageData
    /// お気に入りか否かを表すプロパティ。
    var isFavorite: Bool
    /// 取得日を表すプロパティ。
    let acquisitionDate: Date
    
    /// ``YDMCard``のイニシャライザ。
    /// - Parameters:
    ///   - name: カード名。
    ///   - normalSizeImageData: ``YDMCard``.``YDMCard/imageData-swift.property``.``YDMCard/ImageData-swift.struct/normal``に設定する画像データ。
    ///   - smallSizeImageData: ``YDMCard``.``YDMCard/imageData-swift.property``.``YDMCard/ImageData-swift.struct/small``に設定する画像データ。
    ///   - isFavorite: お気に入りか否かを示すブール値
    init(name: String, normalSizeImageData: Data, smallSizeImageData: Data, isFavorite: Bool = false) {
        self.name = name
        self.imageData = .init(normal: normalSizeImageData, small: smallSizeImageData)
        self.isFavorite = isFavorite
        self.acquisitionDate = .init()
    }
    
    /// 画像データを表現するバリューオブジェクト。ノーマルサイズの画像データ、スモールサイズの画像データをもつ。
    struct ImageData: Codable {
        let normal, small: Data
    }

    /// ``YDMCard/DTO``を受け取り、``YDMCard``を生成する静的関数。
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
    /// ``YDMCard``のデータトランスファーオブジェクト。スレッド（タスク）間を越えることができない場合などに用いる。
    struct DTO: Decodable {
        /// カード名を表すプロパティ。
        let name: String
        /// 画像データを表すプロパティ。
        let imageData: ImageData
        /// お気に入りか否かを表すプロパティ。
        var isFavorite: Bool
        /// 取得日を表すプロパティ。
        let acquisitionDate: Date

        /// ``YDMCard/DTO``のイニシャライザ。
        /// - Parameters:
        ///   - name: カード名
        ///   - normalSizeImageData: ノーマルサイズの画像データ。
        ///   - smallSizeImageData: スモールサイズの画像データ
        ///   - isFavorite: お気に入りか否かを示すブール値
        init(name: String, normalSizeImageData: Data, smallSizeImageData: Data, isFavorite: Bool = false) {
            self.name = name
            self.imageData = .init(normal: normalSizeImageData, small: smallSizeImageData)
            self.isFavorite = isFavorite
            self.acquisitionDate = .init()
        }
    }
}

extension YDMCard {
    /// ``YDMCard``のサンプルを返す関数。（ブラック・マジシャン）
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

    /// ``YDMCard``配列のサンプルを返す関数。（すべてブラック・マジシャン）
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
