import UIKit

class PomodoroViewController: UIViewController {
    private let headerView = CustomHeaderView()
    private let progressView = ProgressCircleView()
    
    private let startButton = UIButton()
    private let resetButton = UIButton()
    
    private let mainStackView = UIStackView()
    private let buttonStackView = UIStackView()
    
    private var isRunning = false
    private var isPaused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupHeaderView()
        setupMainStackView()
        setupProgressCallback()
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
        mainStackView.spacing = 40
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 30),
            mainStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -30)
        ])
        
        setupProgressView()
        setupButtonStackView()
        
        mainStackView.addArrangedSubview(progressView)
        mainStackView.addArrangedSubview(buttonStackView)
    }
    
    private func setupButtonStackView() {
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonStackView.widthAnchor.constraint(equalToConstant: min(view.frame.width - 60, 300))
        ])
        
        setupButton(startButton, title: "Start", titleColor: .black, bgColor: .orange)
        startButton.addTarget(self, action: #selector(onStartStopTapped), for: .touchUpInside)
        
        setupButton(resetButton, title: "Reset", titleColor: .white, bgColor: .black, borderWidth: 2, borderColor: UIColor.white.cgColor)
        resetButton.addTarget(self, action: #selector(onResetTapped), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(startButton)
        buttonStackView.addArrangedSubview(resetButton)
    }

    private func setupProgressView() {
        progressView.duration = 60
        progressView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 250),
            progressView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func setupProgressCallback() {
        progressView.onTimerComplete = { [weak self] in
            self?.onTimerComplete()
        }
    }
    
    private func setupButton(_ button: UIButton, title: String, titleColor: UIColor, bgColor: UIColor, borderWidth: CGFloat = 0, borderColor: CGColor = UIColor.clear.cgColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 8
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func onStartStopTapped() {
        if !isRunning {
            if isPaused {
                progressView.resumeProgress()
                isPaused = false
            } else {
                progressView.startProgress()
            }
            isRunning = true
            updateButtonStates()
        } else {
            progressView.pauseProgress()
            isRunning = false
            isPaused = true
            updateButtonStates()
        }
    }
    
    @objc private func onResetTapped() {
        progressView.resetProgress()
        isRunning = false
        isPaused = false
        updateButtonStates()
    }
    
    private func updateButtonStates() {
        if isRunning {
            startButton.setTitle("Pause", for: .normal)
        } else if isPaused {
            startButton.setTitle("Resume", for: .normal)
        } else {
            startButton.setTitle("Start", for: .normal)
        }
    }
    
    private func onTimerComplete() {
        isRunning = false
        isPaused = false
        updateButtonStates()
        
        // Show completion alert
        let alert = UIAlertController(title: "Pomodoro Complete!", message: "Time for a break!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.progressView.resetProgress()
        })
        present(alert, animated: true)
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isRunning {
            progressView.pauseProgress()
        }
    }
}
