import UIKit

class PedometerViewController: UIViewController {
    private let headerView = CustomHeaderView()
    
    private var startTime: Date?
    private var displayLink: CADisplayLink?

    private var count: Int = 0
    private var isCounting: Bool = false
    private var timeBeforeStop: TimeInterval = 0
    
    private let mainStackView = UIStackView()
    private let buttonStackView = UIStackView()
    
    private let timeLabel = UILabel()
    private let startButton = UIButton()
    private let stepButton = UIButton()
    private let resetButton = UIButton()
    
    private let pickerView = UIPickerView()
    private var pickerViewHeightConstraint: NSLayoutConstraint!
    var timeSteps: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupHeaderView()
        setupMainStackView()
        setupButtonStackView()
    }
    
    private func setupHeaderView() {
        navigationController?.isNavigationBarHidden = true
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.configure(title: "", bgColor: .clear, colorTitle: .white, backButtonColor: .white)
        
        headerView.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupMainStackView() {
        view.addSubview(mainStackView)
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        mainStackView.addArrangedSubview(timeLabel)
        mainStackView.addArrangedSubview(pickerView)
        mainStackView.addArrangedSubview(buttonStackView)
        
        setupLabel()
        setupPickerView()
        setupButtonStackView()
    }

    func setupPickerView() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = .clear
        
        // Initially hidden
        pickerViewHeightConstraint = pickerView.heightAnchor.constraint(equalToConstant: 0)
        pickerViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            pickerView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
    }
    
    func setupButtonStackView() {
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonStackView.widthAnchor.constraint(equalToConstant: view.frame.width - 60)
        ])
        
        setupButton(stepButton, title: "Step", titleColor: .white, bgColor: .black, borderWidth: 2, borderColor: UIColor.white.cgColor)
        stepButton.isHidden = true
        stepButton.addTarget(self, action: #selector(onStepTapped), for: .touchUpInside)
        
        setupButton(startButton, title: "Start", titleColor: .black, bgColor: .orange)
        startButton.addTarget(self, action: #selector(onStartStopTapped), for: .touchUpInside)
        
        setupButton(resetButton, title: "Reset", titleColor: .white, bgColor: .black, borderWidth: 2, borderColor: UIColor.white.cgColor)
        resetButton.addTarget(self, action: #selector(timerReset), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(stepButton)
        buttonStackView.addArrangedSubview(startButton)
        buttonStackView.addArrangedSubview(resetButton)
    }
    
    private func setupButton(_ button: UIButton, title: String, titleColor: UIColor, bgColor: UIColor, borderWidth: CGFloat = 0, borderColor: CGColor = UIColor.clear.cgColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 8
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    func setupLabel() {
        timeLabel.text = "00:00:00"
        timeLabel.font = .systemFont(ofSize: 30, weight: .bold)
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
    
    @objc func onStartStopTapped() {
        if isCounting {
            if let startTime = startTime {
                timeBeforeStop += Date().timeIntervalSince(startTime)
            }

            isCounting = false
            displayLink?.invalidate()
            displayLink = nil
            startButton.setTitle("Start", for: .normal)
            stepButton.isHidden = !isCounting
        } else {
            isCounting = true
            startTime = Date()
            displayLink = CADisplayLink(target: self, selector: #selector(updateDisplayTime))
            displayLink?.add(to: .current, forMode: .common)
            startButton.setTitle("Stop", for: .normal)
            stepButton.isHidden = !isCounting
        }
    }
    
    @objc func updateDisplayTime() {
        guard let startTime = startTime else { return }

        let elapsed = Date().timeIntervalSince(startTime) + timeBeforeStop

        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        let centiseconds = Int((elapsed - floor(elapsed)) * 100)

        let timeString = String(format: "%02d:%02d:%02d", minutes, seconds, centiseconds)
        timeLabel.text = timeString
    }
    
    @objc func timerReset() {
        isCounting = false
        displayLink?.invalidate()
        displayLink = nil
        startTime = nil
        timeBeforeStop = 0
        timeLabel.text = "00:00:00"
        startButton.setTitle("Start", for: .normal)
        
        timeSteps.removeAll()
        pickerView.reloadAllComponents()
        
        stepButton.isHidden = !isCounting
        
        UIView.animate(withDuration: 0.3) {
            self.pickerViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func onStepTapped() {
        guard let currentTime = timeLabel.text, isCounting else { return }
        
        if pickerViewHeightConstraint.constant == 0 {
            UIView.animate(withDuration: 0.3) {
                self.pickerViewHeightConstraint.constant = 150
                self.view.layoutIfNeeded()
            }
        }
        
        timeSteps.append(currentTime)
        pickerView.reloadAllComponents()
        
        let lastRow = timeSteps.count - 1
        if lastRow >= 0 {
            pickerView.selectRow(lastRow, inComponent: 0, animated: true)
        }
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

extension PedometerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // Number of components (columns)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of rows in component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeSteps.count
    }
    
    // Title for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Step \(row + 1): \(timeSteps[row])"
    }
    
    // Custom view for each row to match dark theme
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = "Step \(row + 1): \(timeSteps[row])"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white // White text for dark theme
        label.textAlignment = .center
        return label
    }
    
    // Row height
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        
//    }
}
