import Foundation

extension Array {
    /// 配列の要素を指定されたサイズのチャンクに分割する。
    /// - Parameter size: 各チャンクの最大サイズ。
    /// - Returns: チャンクの配列。
    func chuncked(_ size: Int) -> [[Element]] {
        makeChunks(self, chunkSize: size)
    }
}

/// 指定されたサイズで`Array`をチャンクに分割するプライベート関数。
/// - Parameters:
///   - array: 分割元の`Array`。
///   - chunkSize: 各チャンクの最大サイズ。
/// - Returns: チャンクの配列。
private func makeChunks<T>(_ array: [T], chunkSize: Int) -> [[T]] {
    let result: StrideTo<Int> = stride(from: 0, to: array.count, by: chunkSize)

    return result.map {
        let startIndex = $0
        let endIndex = min(startIndex + chunkSize, array.count)
        let range = startIndex..<endIndex
        return .init(array[range])
    }
}
