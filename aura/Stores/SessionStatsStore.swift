import Foundation

final class SessionStatsStore: ObservableObject {
    @Published private(set) var records: [SessionRecord]

    private let defaults: UserDefaults
    private let calendar: Calendar

    init(defaults: UserDefaults = .standard, calendar: Calendar = .current) {
        self.defaults = defaults
        self.calendar = calendar

        if let data = defaults.data(forKey: Keys.records),
           let decoded = try? JSONDecoder().decode([SessionRecord].self, from: data) {
            records = decoded.sorted { $0.completedAt > $1.completedAt }
        } else {
            records = []
        }
    }

    var todayCompletedSessions: Int {
        completedSessions(on: Date())
    }

    var totalSessions: Int {
        records.count
    }

    var totalMindfulMinutes: Int {
        let seconds = records.reduce(0) { $0 + $1.durationSeconds }
        return Int(ceil(Double(seconds) / 60.0))
    }

    var currentStreak: Int {
        Self.currentStreak(from: records, calendar: calendar, referenceDate: Date())
    }

    var longestStreak: Int {
        Self.longestStreak(from: records, calendar: calendar)
    }

    var averageSessionSeconds: Int {
        guard !records.isEmpty else { return 0 }
        let total = records.reduce(0) { $0 + $1.durationSeconds }
        return total / records.count
    }

    func recordCompletion(
        pattern: BreathingPattern,
        durationSeconds: Int? = nil,
        completedAt: Date = Date()
    ) {
        let record = SessionRecord(
            patternName: pattern.name,
            durationSeconds: durationSeconds ?? pattern.totalDurationSeconds,
            completedAt: completedAt
        )
        records.insert(record, at: 0)
        save()
    }

    func completedSessions(on date: Date) -> Int {
        records.filter { calendar.isDate($0.completedAt, inSameDayAs: date) }.count
    }

    func clear() {
        records = []
        save()
    }

    static func currentStreak(
        from records: [SessionRecord],
        calendar: Calendar,
        referenceDate: Date
    ) -> Int {
        let completedDays = Set(records.map { calendar.startOfDay(for: $0.completedAt) })
        guard !completedDays.isEmpty else { return 0 }

        let today = calendar.startOfDay(for: referenceDate)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today

        let anchor: Date
        if completedDays.contains(today) {
            anchor = today
        } else if completedDays.contains(yesterday) {
            anchor = yesterday
        } else {
            return 0
        }

        var streak = 0
        var cursor = anchor
        while completedDays.contains(cursor) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else {
                break
            }
            cursor = previous
        }
        return streak
    }

    static func longestStreak(
        from records: [SessionRecord],
        calendar: Calendar
    ) -> Int {
        let completedDays = Set(records.map { calendar.startOfDay(for: $0.completedAt) })
        let sortedDays = completedDays.sorted()
        guard !sortedDays.isEmpty else { return 0 }

        var longest = 1
        var current = 1
        var previousDay = sortedDays[0]

        for day in sortedDays.dropFirst() {
            let distance = calendar.dateComponents([.day], from: previousDay, to: day).day
            if distance == 1 {
                current += 1
            } else {
                current = 1
            }

            longest = max(longest, current)
            previousDay = day
        }

        return longest
    }

    private func save() {
        if let data = try? JSONEncoder().encode(records) {
            defaults.set(data, forKey: Keys.records)
        }
    }

    private enum Keys {
        static let records = "aura.stats.sessionRecords"
    }
}
