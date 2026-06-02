import Foundation

struct SessionRecord: Identifiable, Codable, Equatable {
    let id: UUID
    let patternName: String
    let durationSeconds: Int
    let completedAt: Date

    init(
        id: UUID = UUID(),
        patternName: String,
        durationSeconds: Int,
        completedAt: Date = Date()
    ) {
        self.id = id
        self.patternName = patternName
        self.durationSeconds = durationSeconds
        self.completedAt = completedAt
    }
}
