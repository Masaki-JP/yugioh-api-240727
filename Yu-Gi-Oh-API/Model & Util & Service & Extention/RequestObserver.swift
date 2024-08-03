import Foundation

/// APIリクエストをレート制限するためのオブザーバー。指定された時間内に予科されるリクエストの最大数を管理し、必要に応じて遅延時間を提供する。
///
/// >Important: Rate Limit: 20 requests per second
actor RequestObserver {
    /// 遅延時間を表すタイプエイリアス。
    typealias DelayTime = Double
    /// リクエストのタイムスタンプを格納する配列。
    private var timeStamps: [Double] = .init()
    
    /// リクエストまでの適切な遅延時間を計算し、それを返す。
    ///
    /// このメソッドは、直近1秒間に許可されたリクエスト数が18未満である場合、直ちにリクエストを許可します。
    /// それ以外の場合、1秒間に18リクエストが完了しているかを確認し、必要な遅延を計算して返します。
    ///
    /// - Returns: リクエストが許可されるまでの遅延時間。遅延が不要な場合は`nil`を返します。
    func apply() -> DelayTime? {
        timeStamps.removeAll { timeStamp in
            Date.now.timeIntervalSince1970 - timeStamp > 1.0
        }

        guard
            timeStamps.count >= 18,
            case let range = (timeStamps.count - 18) ..< (timeStamps.count),
            case let currentTimeStamps = timeStamps[range],
            let oldestTimeStamp = currentTimeStamps.first
        else {
            timeStamps.append(Date.now.timeIntervalSince1970)
            return nil
        }

        let delayTime = oldestTimeStamp + 1.0 - Date.now.timeIntervalSince1970
        timeStamps.append(Date.now.timeIntervalSince1970 + delayTime)
        return delayTime > 0 ? delayTime : nil
    }
}
