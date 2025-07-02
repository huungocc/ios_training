import Foundation

struct PomodoroState {
    let isRunning: Bool
    let isPaused: Bool
    let remainingTime: TimeInterval
    let totalDuration: TimeInterval
    let formattedTime: String
    let progress: Float
}

enum PomodoroAction {
    case start
    case pause
    case resume
    case reset
    case complete
}
