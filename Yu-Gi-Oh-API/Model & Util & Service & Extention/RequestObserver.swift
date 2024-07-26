import Foundation

/// APIRL: 20 requests per second
actor RequestObserver {
    typealias DelayTime = Double
    private var timeStamps: [Double] = .init()

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
