import Foundation
import QuartzCore
import Combine

class PedometerViewModel: ObservableObject {
    @Published var timerState = TimerState(isRunning: false, currentTime: "00:00:00", totalElapsedTime: 0)
    @Published var stepRecords: [StepRecord] = []
    
    private var startTime: Date?
    private var displayLink: CADisplayLink?
    private var timeBeforeStop: TimeInterval = 0
    
    var startButtonTitle: String {
        return timerState.isRunning ? "Stop" : "Start"
    }
    
    var shouldShowStepButton: Bool {
        return timerState.isRunning
    }
    
    func startStopTimer() {
        if timerState.isRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    func recordStep() {
        guard timerState.isRunning else { return }
        
        let stepRecord = StepRecord(
            stepNumber: stepRecords.count + 1,
            timeStamp: timerState.currentTime
        )
        
        stepRecords.append(stepRecord)
    }
    
    func resetTimer() {
        stopTimer()
        startTime = nil
        timeBeforeStop = 0
        stepRecords.removeAll()
        
        updateStopTime()
    }
    
    private func startTimer() {
        startTime = Date()
        displayLink = CADisplayLink(target: self, selector: #selector(updateDisplayTime))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    private func stopTimer() {
        if let startTime = startTime {
            timeBeforeStop += Date().timeIntervalSince(startTime)
        }
        
        displayLink?.invalidate()
        displayLink = nil
        
        updateStopTime()
    }
    
    @objc private func updateDisplayTime() {
        guard let startTime = startTime else { return }
        
        let elapsed = Date().timeIntervalSince(startTime) + timeBeforeStop
        let timeString = formatTime(elapsed)
        
        timerState = TimerState(
            isRunning: true,
            currentTime: timeString,
            totalElapsedTime: elapsed
        )
    }
    
    private func updateStopTime() {
        let timeString = formatTime(timeBeforeStop)
        
        timerState = TimerState(
            isRunning: displayLink != nil,
            currentTime: timeString,
            totalElapsedTime: timeBeforeStop
        )
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let centiseconds = Int((timeInterval - floor(timeInterval)) * 100)
        
        return String(format: "%02d:%02d:%02d", minutes, seconds, centiseconds)
    }
    
    deinit {
        displayLink?.invalidate()
    }
}
