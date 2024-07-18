import UIKit

func getSampleCard() -> YDMCard {
    let uiImage_normal = UIImage(named: "Dark_Magician_Normal")!
    let uiImage_small = UIImage(named: "Dark_Magician_Small")!
    let normalSizeImageData = uiImage_normal.jpegData(compressionQuality: 0.05)!
    let smallSizeImageData = uiImage_small.jpegData(compressionQuality: 0.05)!

    return .init(
        name: "Dark Magician",
        normalSizeImageData: normalSizeImageData,
        smallSizeImageData: smallSizeImageData
    )
}

func getSampleCards(_ numberOfCard: Int) -> [YDMCard] {
    let uiImage_normal = UIImage(named: "Dark_Magician_Normal")!
    let uiImage_small = UIImage(named: "Dark_Magician_Small")!
    let normalSizeImageData = uiImage_normal.jpegData(compressionQuality: 0.05)!
    let smallSizeImageData = uiImage_small.jpegData(compressionQuality: 0.05)!

    return (0..<numberOfCard).map { _ in
            .init(
                name: "Dark Magician",
                normalSizeImageData: normalSizeImageData,
                smallSizeImageData: smallSizeImageData
            )
    }
}
