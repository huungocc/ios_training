import Foundation
import Combine

class PomodoroViewModel: ObservableObject {
    @Published var pomodoroState: PomodoroState
    @Published var shouldShowCompletionAlert = false
    
    private var timer: Timer?
    private let totalDuration: TimeInterval
    
    var startButtonTitle: String {
        if pomodoroState.isRunning {
            return "Pause"
        } else if pomodoroState.isPaused {
            return "Resume"
        } else {
            return "Start"
        }
    }
    
    var progressValue: Float {
        return pomodoroState.progress
    }
    
    init(duration: TimeInterval = 60) {
        self.totalDuration = duration
        self.pomodoroState = PomodoroState(
            isRunning: false,
            isPaused: false,
            remainingTime: duration,
            totalDuration: duration,
            formattedTime: PomodoroViewModel.formatTime(duration),
            progress: 1.0
        )
    }
    
    func handleAction(_ action: PomodoroAction) {
        switch action {
        case .start:
            startTimer()
        case .pause:
            pauseTimer()
        case .resume:
            startTimer()
        case .reset:
            resetTimer()
        case .complete:
            completeTimer()
        }
    }
    
    private func startTimer() {
        guard !pomodoroState.isRunning else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
        
        updateState(isRunning: true, isPaused: false)
    }
    
    private func pauseTimer() {
        timer?.invalidate()
        timer = nil
        updateState(isRunning: false, isPaused: true)
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        
        pomodoroState = PomodoroState(
            isRunning: false,
            isPaused: false,
            remainingTime: totalDuration,
            totalDuration: totalDuration,
            formattedTime: Self.formatTime(totalDuration),
            progress: 1.0
        )
    }
    
    private func completeTimer() {
        timer?.invalidate()
        timer = nil
        
        updateState(isRunning: false, isPaused: false)
        shouldShowCompletionAlert = true
    }
    
    private func updateTimer() {
        let newRemainingTime = pomodoroState.remainingTime - 1
        
        if newRemainingTime < 0 {
            completeTimer()
        } else {
            let progress = Float(newRemainingTime / totalDuration)
            let formattedTime = Self.formatTime(newRemainingTime)
            
            pomodoroState = PomodoroState(
                isRunning: pomodoroState.isRunning,
                isPaused: pomodoroState.isPaused,
                remainingTime: newRemainingTime,
                totalDuration: totalDuration,
                formattedTime: formattedTime,
                progress: progress
            )
        }
    }
    
    private func updateState(isRunning: Bool, isPaused: Bool) {
        pomodoroState = PomodoroState(
            isRunning: isRunning,
            isPaused: isPaused,
            remainingTime: pomodoroState.remainingTime,
            totalDuration: totalDuration,
            formattedTime: pomodoroState.formattedTime,
            progress: pomodoroState.progress
        )
    }
    
    private static func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func dismissCompletionAlert() {
        shouldShowCompletionAlert = false
    }
    
    deinit {
        timer?.invalidate()
    }
}
