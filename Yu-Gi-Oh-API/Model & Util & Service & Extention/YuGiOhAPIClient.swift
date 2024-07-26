import UIKit

struct YuGiOhAPIClient {
    static private let requestObserver = RequestObserver()

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

        @Sendable func _fetch() async -> YDMCard.DTO? {
            guard
                let url = URL(string: "https://db.ygoprodeck.com/api/v7/randomcard.php"),
                case let delayTime = await Self.requestObserver.apply(),
                case _ = try? await Task.sleep(for: .seconds(delayTime ?? 0.0)),
                let (data, _) = try? await URLSession.shared.data(from: url),
                let responseDTO = try? JSONDecoder().decode(ResponseDTO.self, from: data),
                let normalSizeImageURLString = responseDTO.card_images.first?.image_url,
                let normalSizeImageURL = URL(string: normalSizeImageURLString),
                case let delayTime = await Self.requestObserver.apply(),
                case _ = try? await Task.sleep(for: .seconds(delayTime ?? 0.0)),
                let (normalSizeImageData, _) = try? await URLSession.shared.data(from: normalSizeImageURL),
                let uiImage = UIImage(data: normalSizeImageData),
                let normalSizeImageData = uiImage.jpegData(compressionQuality: 0.0),
                let smallSizeImageURLString = responseDTO.card_images.first?.image_url_small,
                let smallSizeImageURL = URL(string: smallSizeImageURLString),
                case let delayTime = await Self.requestObserver.apply(),
                case _ = try? await Task.sleep(for: .seconds(delayTime ?? 0.0)),
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

        struct ResponseDTO: Decodable {
            let name: String
            let card_images: [CardImage]

            struct CardImage: Decodable {
                let image_url: String
                let image_url_small: String
            }
        }
    }
}

extension YuGiOhAPIClient {
    func fetchSpecialCards() async -> [YDMCard.DTO]? {
        let cardInfoList: [(name: String, cardImagesIndex: Int)] = [
            ("Dark Magician", 2), ("Dark Magician Girl", 0), ("Blue-Eyes White Dragon", 0), ("Blue-Eyes Ultimate Dragon", 0), ("Red-Eyes Black Dragon", 1), ("Relinquished", 0), ("XYZ-Dragon Cannon", 1), ("Jinzo", 0), ("Summoned Skull", 0), ("Dark Necrofear", 0), ("Monster Reborn", 1), ("Axe of Despair", 0), ("Polymerization", 0), ("Harpie's Feather Duster", 0), ("Swords of Revealing Light", 0), ("Mirror Force", 0), ("Destiny Board", 0), ("Call of the Haunted", 0), ("Magic Cylinder", 0), ("Skull Dice", 0)
        ]

        return await withTaskGroup(of: YDMCard.DTO?.self) { group in
            cardInfoList.forEach { cardInfo in
                group.addTask {
                    await fetchSpecialCard(name: cardInfo.name, cardImagesIndex: cardInfo.cardImagesIndex)
                }
            }

            let cardDTOs: [YDMCard.DTO] = await group.compactMap { $0 }.reduce(into: [YDMCard.DTO]()) { $0.append($1) }
            let sortedCardDTOs: [YDMCard.DTO] = cardInfoList.compactMap { cardInfo in
                cardDTOs.filter { cardInfo.name == $0.name }.first
            }

            guard sortedCardDTOs.count == cardInfoList.count else { return nil }
            return sortedCardDTOs
        }

        @Sendable func fetchSpecialCard(name: String, cardImagesIndex: Int) async -> YDMCard.DTO? {
            guard
                let url = URL(string: "https://db.ygoprodeck.com/api/v7/cardinfo.php?name=" + name),
                case let delayTime = await Self.requestObserver.apply(),
                case _ = try? await Task.sleep(for: .seconds(delayTime ?? 0.0)),
                let (data, _) = try? await URLSession.shared.data(from: url),
                let responseDTO2 = try? JSONDecoder().decode(ResponseDTO.self, from: data),
                let responseDTO = responseDTO2.data.first,
                responseDTO.card_images.count >= cardImagesIndex,
                case let normalSizeImageURLString = responseDTO.card_images[cardImagesIndex].image_url,
                let normalSizeImageURL = URL(string: normalSizeImageURLString),
                case let delayTime = await Self.requestObserver.apply(),
                case _ = try? await Task.sleep(for: .seconds(delayTime ?? 0.0)),
                let (normalSizeImageData, _) = try? await URLSession.shared.data(from: normalSizeImageURL),
                let uiImage = UIImage(data: normalSizeImageData),
                let normalSizeImageData = uiImage.jpegData(compressionQuality: 0.0),
                case let smallSizeImageURLString = responseDTO.card_images[cardImagesIndex].image_url_small,
                let smallSizeImageURL = URL(string: smallSizeImageURLString),
                case let delayTime = await Self.requestObserver.apply(),
                case _ = try? await Task.sleep(for: .seconds(delayTime ?? 0.0)),
                let (smallSizeImageData, _) = try? await URLSession.shared.data(from: smallSizeImageURL),
                let uiImage = UIImage(data: smallSizeImageData),
                let smallSizeImageData = uiImage.jpegData(compressionQuality: 0.0)
            else { return nil }

            return .init(
                name: responseDTO.name,
                normalSizeImageData: normalSizeImageData,
                smallSizeImageData: smallSizeImageData,
                isFavorite: true
            )
        }

        struct ResponseDTO: Decodable {
            let data: [Self.Data]

            struct Data: Decodable {
                let name: String
                let card_images: [CardImage]

                struct CardImage: Decodable {
                    let image_url: String
                    let image_url_small: String
                }
            }
        }
    }
}
