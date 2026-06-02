import XCTest
@testable import aura

final class BreathingSessionEngineTests: XCTestCase {
    @MainActor
    func testPhaseTransitionsForFocusReset() {
        let engine = BreathingSessionEngine(pattern: .focusReset)

        XCTAssertEqual(engine.phase, .inhale)
        XCTAssertEqual(engine.phaseRemainingSeconds, 4)

        engine.advance(by: 4)
        XCTAssertEqual(engine.phase, .holdAfterInhale)
        XCTAssertEqual(engine.phaseRemainingSeconds, 2)

        engine.advance(by: 2)
        XCTAssertEqual(engine.phase, .exhale)
        XCTAssertEqual(engine.phaseRemainingSeconds, 6)
    }

    @MainActor
    func testCompletionStopsAtTotalDuration() {
        let engine = BreathingSessionEngine(pattern: .focusReset)

        engine.advance(by: 500)

        XCTAssertTrue(engine.isComplete)
        XCTAssertFalse(engine.isRunning)
        XCTAssertEqual(engine.elapsedSeconds, BreathingPattern.focusReset.totalDurationSeconds)
        XCTAssertEqual(engine.remainingSeconds, 0)
        XCTAssertEqual(engine.progress, 1)
    }
}
