import Foundation

extension Array {
    func chuncked(_ size: Int) -> [[Element]] {
        makeChunks(self, chunkSize: size)
    }
}

private func makeChunks<T>(_ array: [T], chunkSize: Int) -> [[T]] {
    let result: StrideTo<Int> = stride(from: 0, to: array.count, by: chunkSize)

    return result.map {
        let startIndex = $0
        let endIndex = min(startIndex + chunkSize, array.count)
        let range = startIndex..<endIndex
        return .init(array[range])
    }
}
