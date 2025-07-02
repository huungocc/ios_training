import UIKit
import Combine

class PomodoroViewController: UIViewController {
    private let headerView = CustomHeaderView()
    private let progressView = ProgressCircleView()
    private let startButton = UIButton()
    private let resetButton = UIButton()
    private let mainStackView = UIStackView()
    private let buttonStackView = UIStackView()
    
    private let viewModel = PomodoroViewModel(duration: 60)
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupUI()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if viewModel.pomodoroState.isRunning {
            viewModel.handleAction(.pause)
        }
    }
    
    private func setupUI() {
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
    
    private func setupProgressView() {
        progressView.duration = 60
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 250),
            progressView.heightAnchor.constraint(equalToConstant: 250)
        ])
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
        startButton.addTarget(self, action: #selector(startStopButtonTapped), for: .touchUpInside)
        
        setupButton(resetButton, title: "Reset", titleColor: .white, bgColor: .black, borderWidth: 2, borderColor: UIColor.white.cgColor)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
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
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func bindViewModel() {
        viewModel.$pomodoroState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                self.updateUI(with: state)
            }
            .store(in: &cancellables)
        
        viewModel.$shouldShowCompletionAlert
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldShow in
                guard let self = self else { return }
                if shouldShow {
                    self.showCompletionAlert()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(with state: PomodoroState) {
        progressView.timeText = state.formattedTime
        progressView.progress = state.progress
        
        startButton.setTitle(viewModel.startButtonTitle, for: .normal)
    }
    
    private func showCompletionAlert() {
        let alert = UIAlertController(
            title: "Pomodoro Complete!",
            message: "Time for a break!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.viewModel.dismissCompletionAlert()
            self?.viewModel.handleAction(.reset)
        })
        
        present(alert, animated: true)
    }
    
    @objc private func startStopButtonTapped() {
        let currentState = viewModel.pomodoroState
        
        if currentState.isRunning {
            viewModel.handleAction(.pause)
        } else if currentState.isPaused {
            viewModel.handleAction(.resume)
        } else {
            viewModel.handleAction(.start)
        }
    }
    
    @objc private func resetButtonTapped() {
        viewModel.handleAction(.reset)
    }
}
