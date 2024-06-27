import Foundation

struct APIClient {
    func fetch() async -> Card? {
        guard
            let url = URL(string: "https://db.ygoprodeck.com/api/v7/randomcard.php"),
            let (data, _) = try? await URLSession.shared.data(from: url),
            let cardDTO = try? JSONDecoder().decode(CardDTO.self, from: data),
            let imageURLString = cardDTO.card_images.first?.image_url,
            let imageURL = URL(string: imageURLString),
            let (imageData, _) = try? await URLSession.shared.data(from: imageURL)
        else { return nil }

        return .init(name: cardDTO.name, data: imageData)
    }

    private struct CardDTO: Decodable {
        let name: String
        let card_images: [CardImage]

        struct CardImage: Decodable {
            let image_url: String
        }
    }
}
