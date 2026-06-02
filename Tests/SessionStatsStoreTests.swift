import XCTest
@testable import aura

final class SessionStatsStoreTests: XCTestCase {
    func testStatsAndStreaks() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        let suiteName = "SessionStatsStoreTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let store = SessionStatsStore(defaults: defaults, calendar: calendar)
        let today = calendar.date(from: DateComponents(year: 2026, month: 6, day: 2, hour: 12))!
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!

        store.recordCompletion(pattern: .focusReset, completedAt: twoDaysAgo)
        store.recordCompletion(pattern: .boxBreathing, completedAt: yesterday)
        store.recordCompletion(pattern: .focusReset, completedAt: today)

        XCTAssertEqual(store.totalSessions, 3)
        XCTAssertEqual(store.completedSessions(on: today), 1)
        XCTAssertEqual(store.totalMindfulMinutes, 4)

        XCTAssertEqual(
            SessionStatsStore.currentStreak(from: store.records, calendar: calendar, referenceDate: today),
            3
        )
        XCTAssertEqual(SessionStatsStore.longestStreak(from: store.records, calendar: calendar), 3)
    }
}
