import UIKit

struct YuGiOhAPIClient {
    func fetchCards(_ numberOfCards: Int) async -> [YDMCard.DTO]? {
        guard numberOfCards > 0 else { return nil }
        return await withTaskGroup(of: YDMCard.DTO?.self) { group in
            for _ in 0..<numberOfCards {
                try? await Task.sleep(for: .seconds(0.01))
                group.addTask(operation: _fetch)
            }
            let cards = await group.compactMap { $0 }.reduce(into: [YDMCard.DTO]()) { $0.append($1) }
            return cards.count == numberOfCards ? cards : nil
        }
    }

    @Sendable private func _fetch() async -> YDMCard.DTO? {
        guard
            let url = URL(string: "https://db.ygoprodeck.com/api/v7/randomcard.php"),
            let (data, _) = try? await URLSession.shared.data(from: url),
            let responseDTO = try? JSONDecoder().decode(ResponseDTO.self, from: data),
            let normalSizeImageURLString = responseDTO.card_images.first?.image_url,
            let normalSizeImageURL = URL(string: normalSizeImageURLString),
            let (normalSizeImageData, _) = try? await URLSession.shared.data(from: normalSizeImageURL),
            let uiImage = UIImage(data: normalSizeImageData),
            let normalSizeImageData = uiImage.jpegData(compressionQuality: 0.0),
            let smallSizeImageURLString = responseDTO.card_images.first?.image_url_small,
            let smallSizeImageURL = URL(string: smallSizeImageURLString),
            let (smallSizeImageData, _) = try? await URLSession.shared.data(from: smallSizeImageURL),
            let uiImage = UIImage(data: smallSizeImageData),
            let smallSizeImageData = uiImage.jpegData(compressionQuality: 0.0)
        else { return nil }

        return .init(
            name: responseDTO.name,
            normalSizeImageData: normalSizeImageData,
            smallSizeImageData: smallSizeImageData
        )
    }

    private struct ResponseDTO: Decodable {
        let name: String
        let card_images: [CardImage]

        struct CardImage: Decodable {
            let image_url: String
            let image_url_small: String
        }
    }
}
