import UIKit

class PedometerViewController: UIViewController {
    
    private var timer: Timer = Timer()
    private var count: Int = 0
    private var isCounting: Bool = false
    
    private var mainStackView = UIStackView()
    private var buttonStackView = UIStackView()
    
    private var timeLabel = UILabel()
    private var startButton = UIButton()
    private var resetButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupMainStackView()
        
        setupLabel()
        
        setupButtonStackView()
        
    }
    
    func setupMainStackView() {
        view.addSubview(mainStackView)
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 50
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        setupLabel()
        setupButtonStackView()
        
        mainStackView.addArrangedSubview(timeLabel)
        mainStackView.addArrangedSubview(buttonStackView)
    }

    
    func setupButtonStackView() {
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonStackView.widthAnchor.constraint(equalToConstant: view.frame.width - 60).isActive = true

        setupButton(startButton, title: "Start", titleColor: .black, bgColor: .orange, action: #selector(onStartStopTapped))
        setupButton(resetButton, title: "Reset", titleColor: .white, bgColor: .black, borderWidth: 2, borderColor: UIColor.white.cgColor, action: #selector(timerReset))
        
        buttonStackView.addArrangedSubview(startButton)
        buttonStackView.addArrangedSubview(resetButton)
    }

    
    func setupLabel() {
        timeLabel.text = "00:00:00"
        timeLabel.textAlignment = .center
        timeLabel.textColor = .white
        timeLabel.backgroundColor = .black
        timeLabel.clipsToBounds = true
        timeLabel.layer.borderWidth = 2
        timeLabel.layer.cornerRadius = 100
        timeLabel.layer.borderColor = UIColor.orange.cgColor
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }

    
    func setupButton(_ button: UIButton, title: String, titleColor: UIColor, bgColor: UIColor, borderWidth: CGFloat? = nil, borderColor: CGColor? = nil, action: Selector) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        if let borderWidth = borderWidth {
            button.layer.borderWidth = borderWidth
        }
        if let borderColor = borderColor {
            button.layer.borderColor = borderColor
        }
        button.addTarget(self, action: action, for: .touchUpInside)
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
}
