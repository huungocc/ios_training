import UIKit

class ViewController: UIViewController {
    private let stackView = UIStackView(arrangedSubviews: [])
    
    private let nowTimeButton = UIButton(type: .system)
    private let pedometerButton = UIButton(type: .system)
    private let onBoardingButton = UIButton(type: .system)
    private let movieButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupButton(nowTimeButton, title: "Now Time", action: #selector(handleNowTimeTapped))
        setupButton(pedometerButton, title: "Pedometer", action: #selector(handlePedometerTapped))
        setupButton(onBoardingButton, title: "On Boarding", action: #selector(navigateToOnBoarding))
        setupButton(movieButton, title: "Movie", action: #selector(navigateToMovie))
        
        setupStackView()
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
        
        stackView.addArrangedSubview(nowTimeButton)
        stackView.addArrangedSubview(pedometerButton)
        stackView.addArrangedSubview(onBoardingButton)
        stackView.addArrangedSubview(movieButton)
    }
    
    private func setupButton(_ button: UIButton, title: String, action: Selector) {
        button.setTitle(title, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    @objc private func handleNowTimeTapped() {
        let timeNowVC = TimeNowViewController()
        navigationController?.pushViewController(timeNowVC, animated: true)
    }
    
    @objc private func handlePedometerTapped() {
        let pedometerVC = PedometerViewController()
        navigationController?.pushViewController(pedometerVC, animated: true)
    }
    
    @objc private func navigateToOnBoarding() {
        let onBoardingVC = OnBoardingViewController()
        navigationController?.pushViewController(onBoardingVC, animated: true)
    }
    
    @objc private func navigateToMovie() {
        let movieVC = MoviesViewController()
        navigationController?.pushViewController(movieVC, animated: true)
    }
}
