import Foundation

@MainActor
final class BreathingSessionEngine: ObservableObject {
    let pattern: BreathingPattern

    @Published private(set) var elapsedSeconds: Int = 0
    @Published private(set) var phase: BreathingPhase
    @Published private(set) var phaseRemainingSeconds: Int
    @Published private(set) var isRunning = false
    @Published private(set) var isComplete = false

    private var timer: Timer?

    init(pattern: BreathingPattern) {
        self.pattern = pattern
        let initialState = Self.phaseState(for: 0, pattern: pattern)
        phase = initialState.phase
        phaseRemainingSeconds = initialState.remainingSeconds
    }

    var remainingSeconds: Int {
        max(0, pattern.totalDurationSeconds - elapsedSeconds)
    }

    var progress: Double {
        guard pattern.totalDurationSeconds > 0 else { return 1 }
        return min(1, Double(elapsedSeconds) / Double(pattern.totalDurationSeconds))
    }

    func start() {
        guard !isComplete else { return }
        guard !isRunning else { return }
        isRunning = true
        scheduleTimer()
    }

    func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func resume() {
        start()
    }

    func end() {
        pause()
        elapsedSeconds = pattern.totalDurationSeconds
        isComplete = true
        updatePhaseState()
    }

    func reset() {
        pause()
        elapsedSeconds = 0
        isComplete = false
        updatePhaseState()
    }

    func advance(by seconds: Int) {
        guard seconds > 0, !isComplete else { return }

        for _ in 0..<seconds {
            elapsedSeconds = min(pattern.totalDurationSeconds, elapsedSeconds + 1)
            updatePhaseState()

            if elapsedSeconds >= pattern.totalDurationSeconds {
                isComplete = true
                pause()
                break
            }
        }
    }

    static func phaseState(
        for elapsedSeconds: Int,
        pattern: BreathingPattern
    ) -> (phase: BreathingPhase, remainingSeconds: Int) {
        let timeline = pattern.phaseDurations
        guard let fallback = timeline.last else {
            return (.inhale, 0)
        }

        guard elapsedSeconds < pattern.totalDurationSeconds else {
            return (fallback.phase, 0)
        }

        let cycleDuration = max(1, pattern.cycleDurationSeconds)
        let cycleSecond = elapsedSeconds % cycleDuration
        var cursor = 0

        for item in timeline {
            let end = cursor + item.duration
            if cycleSecond < end {
                return (item.phase, end - cycleSecond)
            }
            cursor = end
        }

        return (fallback.phase, 0)
    }

    private func updatePhaseState() {
        let state = Self.phaseState(for: elapsedSeconds, pattern: pattern)
        phase = state.phase
        phaseRemainingSeconds = state.remainingSeconds
    }

    private func scheduleTimer() {
        timer?.invalidate()
        let newTimer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.advance(by: 1)
            }
        }
        RunLoop.main.add(newTimer, forMode: .common)
        timer = newTimer
    }
}
