import Foundation
import Combine

final class ScrollObserver: ObservableObject {
    @Published private(set) var isScrolling = false
    private var cancellables: Set<AnyCancellable> = .init()
    private let subject: PassthroughSubject<Void, Never> = .init()
    private var debounceCancellable: AnyCancellable? = nil
    private let createdTime: Date
    private var isReady = false

    init() {
        self.createdTime = .now

        subject
            .sink { [weak self] _ in
                if self?.isReady == false  {
                    guard let createdTime = self?.createdTime,
                          Date.now.timeIntervalSince(createdTime) > 0.3 else { return }
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

    func run() { subject.send() }
}
