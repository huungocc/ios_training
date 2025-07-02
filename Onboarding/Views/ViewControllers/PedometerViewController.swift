import UIKit
import Combine

class PedometerViewController: UIViewController {
    private let headerView = CustomHeaderView()
    private let mainStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private let timeLabel = UILabel()
    private let startButton = UIButton()
    private let stepButton = UIButton()
    private let resetButton = UIButton()
    private let pickerView = UIPickerView()
    private var pickerViewHeightConstraint: NSLayoutConstraint!
    
    private let viewModel = PedometerViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        setupHeaderView()
        setupMainStackView()
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
    
    private func setupMainStackView() {
        view.addSubview(mainStackView)
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        setupTimeLabel()
        setupButtons()
        
        mainStackView.addArrangedSubview(timeLabel)
        mainStackView.addArrangedSubview(pickerView)
        mainStackView.addArrangedSubview(buttonStackView)
        
        setupPickerView()
    }
    
    private func setupTimeLabel() {
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
        
        NSLayoutConstraint.activate([
            timeLabel.heightAnchor.constraint(equalToConstant: 200),
            timeLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupPickerView() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = .clear
        
        pickerViewHeightConstraint = pickerView.heightAnchor.constraint(equalToConstant: 0)
        pickerViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
    
    private func setupButtons() {
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonStackView.widthAnchor.constraint(equalToConstant: view.frame.width - 60)
        ])
        
        // Step Button
        setupButton(stepButton, title: "Step", titleColor: .white, bgColor: .black, borderWidth: 2, borderColor: UIColor.white.cgColor)
        stepButton.isHidden = true
        stepButton.addTarget(self, action: #selector(stepButtonTapped), for: .touchUpInside)
        
        // Start Button
        setupButton(startButton, title: "Start", titleColor: .black, bgColor: .orange)
        startButton.addTarget(self, action: #selector(startStopButtonTapped), for: .touchUpInside)
        
        // Reset Button
        setupButton(resetButton, title: "Reset", titleColor: .white, bgColor: .black, borderWidth: 2, borderColor: UIColor.white.cgColor)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
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
    
    private func bindViewModel() {
        viewModel.$timerState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timerState in
                self?.updateUI(with: timerState)
            }
            .store(in: &cancellables)
        
        viewModel.$stepRecords
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.pickerView.reloadAllComponents()
                self?.scrollToLastStep()
            }
            .store(in: &cancellables)

        viewModel.$isPickerVisible
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isVisible in
                self?.animatePickerVisibility(isVisible)
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(with timerState: TimerState) {
        timeLabel.text = timerState.currentTime
        startButton.setTitle(viewModel.startButtonTitle, for: .normal)
        stepButton.isHidden = !viewModel.shouldShowStepButton
    }
    
    private func animatePickerVisibility(_ isVisible: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.pickerViewHeightConstraint.constant = isVisible ? 150 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func scrollToLastStep() {
        let lastRow = viewModel.stepRecords.count - 1
        if lastRow >= 0 {
            pickerView.selectRow(lastRow, inComponent: 0, animated: true)
        }
    }
    
    @objc private func startStopButtonTapped() {
        viewModel.startStopTimer()
    }
    
    @objc private func stepButtonTapped() {
        viewModel.recordStep()
    }
    
    @objc private func resetButtonTapped() {
        viewModel.resetTimer()
    }
}

extension PedometerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.stepRecords.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let stepRecord = viewModel.stepRecords[row]
        return "Step \(stepRecord.stepNumber): \(stepRecord.timeStamp)"
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        let stepRecord = viewModel.stepRecords[row]
        label.text = "Step \(stepRecord.stepNumber): \(stepRecord.timeStamp)"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
