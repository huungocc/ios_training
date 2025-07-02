import UIKit

class TimeNowViewController: UIViewController {
    private let headerView = CustomHeaderView()
    
    private let stackView = UIStackView()
    private let clockTitle = UILabel()
    private let pickerView = UIPickerView()
    
    private let buttonStackView = UIStackView()
    private let stepButton = UIButton()
    private let resetButton = UIButton()
    
    var timer: Timer?
    var currentTime: Date = Date()
    var timeSteps: [String] = []
    
    private var pickerViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupStackView()
        setupHeaderView()
        setupLabel()
        setupButtonStackView()
        setupPickerView()
        
        getTimeNow()
        startTimer()
    }
    
    private func setupHeaderView() {
        navigationController?.isNavigationBarHidden = true
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.configure(title: "", bgColor: .clear, colorTitle: .black, backButtonColor: .black)
        
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
    
    func setupStackView() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.addArrangedSubview(clockTitle)
        stackView.addArrangedSubview(pickerView)
        stackView.addArrangedSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
    func setupLabel() {
        clockTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clockTitle.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        clockTitle.font = .systemFont(ofSize: 60, weight: .bold)
        clockTitle.textAlignment = .center
    }
    
    func setupPickerView() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.backgroundColor = .clear
        
        pickerViewHeightConstraint = pickerView.heightAnchor.constraint(equalToConstant: 0)
        pickerViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            pickerView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
    
    func setupButtonStackView() {
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])

        setupButton(stepButton, title: "Step", titleColor: .black, bgColor: .orange)
        setupButton(resetButton, title: "Reset", titleColor: .white, bgColor: .black)
        
        stepButton.addTarget(self, action: #selector(onStepTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(onResetTapped), for: .touchUpInside)

        buttonStackView.addArrangedSubview(stepButton)
        buttonStackView.addArrangedSubview(resetButton)
    }
    
    private func setupButton(_ button: UIButton, title: String, titleColor: UIColor, bgColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }
    
    func getTimeNow() {
        currentTime = Date()
        updateTimeLabel()
    }
    
    @objc func updateTime() {
        currentTime = currentTime.addingTimeInterval(1)
        updateTimeLabel()
    }
    
    @objc func onStepTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let currentTimeString = dateFormatter.string(from: currentTime)
        timeSteps.append(currentTimeString)
        
        pickerView.reloadAllComponents()
        
        if pickerViewHeightConstraint.constant == 0 {
            UIView.animate(withDuration: 0.3) {
                self.pickerViewHeightConstraint.constant = 150
                self.view.layoutIfNeeded()
            }
        }
        
        let lastRow = timeSteps.count - 1
        if lastRow >= 0 {
            pickerView.selectRow(lastRow, inComponent: 0, animated: true)
        }
    }
    
    @objc func onResetTapped() {
        timeSteps.removeAll()
        pickerView.reloadAllComponents()
        
        UIView.animate(withDuration: 0.3) {
            self.pickerViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func updateTimeLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let currentTimeString = dateFormatter.string(from: currentTime)
        clockTitle.text = currentTimeString
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension TimeNowViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeSteps.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Step \(row + 1): \(timeSteps[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
