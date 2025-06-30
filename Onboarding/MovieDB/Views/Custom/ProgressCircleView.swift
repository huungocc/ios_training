import QuartzCore
import UIKit

class ProgressCircleView: UIView {
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let timeLabel = UILabel()
    private var timer: Timer?
    private var remainingTime: TimeInterval = 0

    var duration: TimeInterval = 60

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }

    private func setupLayers() {
        // Clear existing layers
        backgroundLayer.removeFromSuperlayer()
        progressLayer.removeFromSuperlayer()
        
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 20
        let circlePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: -CGFloat.pi / 2,
            endAngle: CGFloat.pi * 3 / 2,
            clockwise: true
        )

        // Background layer
        backgroundLayer.path = circlePath.cgPath
        backgroundLayer.strokeColor = UIColor.gray.cgColor
        backgroundLayer.lineWidth = 12
        backgroundLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(backgroundLayer)

        // Progress layer
        progressLayer.path = circlePath.cgPath
        progressLayer.strokeColor = UIColor.orange.cgColor
        progressLayer.lineWidth = 12
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 1.0
        layer.addSublayer(progressLayer)
    }

    private func setupLabel() {
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 32, weight: .medium)
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeLabel)

        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timeLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.6),
            timeLabel.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.3)
        ])

        updateTimeLabel(seconds: Int(duration))
    }

    private func updateTimeLabel(seconds: Int) {
        let minutes = seconds / 60
        let secs = seconds % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, secs)
    }

    func startProgress() {
        // Stop any existing timer and animations
        timer?.invalidate()
        progressLayer.removeAllAnimations()
        
        // Reset layer properties to ensure clean state
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        progressLayer.strokeEnd = 1.0

        remainingTime = duration
        updateTimeLabel(seconds: Int(remainingTime))

        // Start circle animation
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        progressLayer.add(animation, forKey: "progress")

        // Start timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingTime -= 1
            if self.remainingTime <= 0 {
                self.timer?.invalidate()
                self.updateTimeLabel(seconds: 0)
                self.onTimerComplete?()
            } else {
                self.updateTimeLabel(seconds: Int(self.remainingTime))
            }
        }
    }

    func resetProgress() {
        // Stop timer and animations
        timer?.invalidate()
        progressLayer.removeAllAnimations()
        
        // Reset all layer properties to initial state
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        progressLayer.strokeEnd = 1.0
        
        // Reset time
        remainingTime = duration
        updateTimeLabel(seconds: Int(remainingTime))
    }
    
    func pauseProgress() {
        timer?.invalidate()
        let pausedTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0.0
        progressLayer.timeOffset = pausedTime
    }
    
    func resumeProgress() {
        let pausedTime = progressLayer.timeOffset
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        let timeSincePause = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressLayer.beginTime = timeSincePause
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingTime -= 1
            if self.remainingTime <= 0 {
                self.timer?.invalidate()
                self.updateTimeLabel(seconds: 0)
                self.onTimerComplete?()
            } else {
                self.updateTimeLabel(seconds: Int(self.remainingTime))
            }
        }
    }
    
    // Callback when timer completes
    var onTimerComplete: (() -> Void)?
}
