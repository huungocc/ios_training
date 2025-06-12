import UIKit

class PedometerViewController: UIViewController {
    
    private var timer: Timer = Timer()
    private var count: Int = 0
    private var isCounting: Bool = false
    
    private let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "00:00:00"
        timeLabel.textAlignment = .center
        timeLabel.textColor = .white
        timeLabel.clipsToBounds = true
        timeLabel.layer.borderWidth = 2
        timeLabel.layer.borderColor = UIColor.orange.cgColor
        return timeLabel
    }()
    
    private let startButton: UIButton = {
        let startButton = UIButton()
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = .orange
        startButton.setTitleColor(.black, for: .normal)
        startButton.layer.cornerRadius = 10
        startButton.clipsToBounds = true
        return startButton
    }()
    
    private let resetButton: UIButton = {
        let resetButton = UIButton()
        resetButton.setTitle("Reset", for: .normal)
        resetButton.backgroundColor = .black
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 10
        resetButton.clipsToBounds = true
        resetButton.layer.borderWidth = 2
        resetButton.layer.borderColor = UIColor.white.cgColor
        return resetButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        view.addSubview(timeLabel)
        view.addSubview(startButton)
        view.addSubview(resetButton)
        
        startButton.addTarget(self, action: #selector(onStartStopTapped), for: .touchUpInside)
        
        resetButton.addTarget(self, action: #selector(timerReset), for: .touchUpInside)
        
    }
    
    @objc func onStartStopTapped() {
        if isCounting {
            isCounting = false
            // stop timer
            timer.invalidate()
            startButton.setTitle("Start", for: .normal)
        } else {
            isCounting = true
            startButton.setTitle("Stop", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerCounter() {
        count += 1
        let time = secondsToHoursMinuteSeconds(count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timeLabel.text = timeString
    }
    
    @objc func timerReset() {
        count = 0
        timer.invalidate()
        timeLabel.text = "00:00:00"
    }
    
    func secondsToHoursMinuteSeconds(_ seconds: Int) -> (Int, Int, Int) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secondsPart = (seconds % 3600) % 60
        return (hours, minutes, secondsPart)
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Kích thước màn hình
        let width = view.frame.size.width
        let labelSize: CGFloat = 150
        let buttonWidth: CGFloat = (width - 100) / 2
        let buttonHeight: CGFloat = 50

        // timeLabel ở giữa trên
        timeLabel.frame = CGRect(
            x: (width - labelSize) / 2,
            y: 150,
            width: labelSize,
            height: labelSize
        )
        timeLabel.layer.cornerRadius = labelSize / 2

        // Start Button bên trái
        startButton.frame = CGRect(
            x: 40,
            y: timeLabel.frame.maxY + 40,
            width: buttonWidth,
            height: buttonHeight
        )

        // Reset Button bên phải
        resetButton.frame = CGRect(
            x: startButton.frame.maxX + 20,
            y: startButton.frame.minY,
            width: buttonWidth,
            height: buttonHeight
        )
    }
}
