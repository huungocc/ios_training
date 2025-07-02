import QuartzCore
import UIKit

class ProgressCircleView: UIView {
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let timeLabel = UILabel()
    
    var progress: Float = 1.0 {
        didSet {
            updateProgress()
        }
    }
    
    var timeText: String = "00:00" {
        didSet {
            timeLabel.text = timeText
        }
    }
    
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
        backgroundLayer.removeFromSuperlayer()
        progressLayer.removeFromSuperlayer()
        
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 20
        let circlePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: .pi * 3 / 2,
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
        progressLayer.strokeEnd = CGFloat(progress)
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
    }
    
    private func updateProgress() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.strokeEnd = CGFloat(progress)
        CATransaction.commit()
    }
}
