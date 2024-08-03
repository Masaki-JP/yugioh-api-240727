import Foundation
import Combine

/// ``VerticalOffsetPreferenceKey``と``IsScrollingPreferenceKey``と連携してスクロール状態を管理するオブザーバー。
///
/// 最後の値が放出されてから0.3秒後に`isScrolling`を`false`に変更する。
///
/// >Note: ビューのレンダリングかかる時間を考慮し、0.3秒間遅延を実装している。
///
final class ScrollObserver: ObservableObject {
    /// スクロール中か否かを表すブール値。
    @Published private(set) var isScrolling = false
    /// 主軸となるサブジェクト。
    private let subject: PassthroughSubject<Void, Never> = .init()
    /// サブジェクトのキャンセラブル。
    private var cancellables: Set<AnyCancellable> = .init()
    /// ``ScrollObserver``が初期化された時間を表すタイムスタンプ。
    private let createdTime: Date
    /// ``ScrollObserver``が処理を始める準備ができているか否かを表すプロパティ。
    private var isReady = false
    /// ジャストパブリッシャーのキャンセラブル。
    private var debounceCancellable: AnyCancellable? = nil

    init() {
        self.createdTime = .now

        subject
            .sink { [weak self] _ in
                if self?.isReady == false  {
                    guard let createdTime = self?.createdTime,
                          Date.now.timeIntervalSince(createdTime) > 0.3 else { return } // 0.3秒の遅延
                    self?.isReady = true
                }

                self?.isScrolling = true

                self?.debounceCancellable?.cancel()
                self?.debounceCancellable = Just(())
                    .delay(for: .seconds(0.3), scheduler: RunLoop.main)
                    .sink { [weak self] _ in
                        self?.isScrolling = false
                    }
            }
            .store(in: &cancellables)
    }
    
    /// スクロールを検知した時に走らせる関数。
    func run() { subject.send() }
}
