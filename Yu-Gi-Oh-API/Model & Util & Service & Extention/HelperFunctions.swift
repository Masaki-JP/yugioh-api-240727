import UIKit

func getSampleCards(_ numberOfCard: Int) -> [YDMCard] {
    let uiImage = UIImage(named: "Dark_Magician_Normal")!
    let imageData = uiImage.jpegData(compressionQuality: 1.0)!

    return (0..<numberOfCard).map { _ in
            .init(name: "Dark Magician", data: imageData)
    }
}
