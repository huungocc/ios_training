import UIKit

class ViewController: UIViewController {
    private let nowTimeButton = UIButton(type: .system)
    private let pedometerButton = UIButton(type: .system)
    private let onBoardingButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupButton(nowTimeButton, title: "Now Time", action: #selector(handleNowTimeTapped))
        setupButton(pedometerButton, title: "Pedometer", action: #selector(handlePedometerTapped))
        setupButton(onBoardingButton, title: "On Boarding", action: #selector(navigateToOnBoarding))
        
        view.addSubview(nowTimeButton)
        view.addSubview(pedometerButton)
        view.addSubview(onBoardingButton)
        
        NSLayoutConstraint.activate([
            onBoardingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onBoardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            onBoardingButton.widthAnchor.constraint(equalToConstant: 200),
            onBoardingButton.heightAnchor.constraint(equalToConstant: 50),
            
            pedometerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pedometerButton.bottomAnchor.constraint(equalTo: onBoardingButton.topAnchor, constant: -20),
            pedometerButton.widthAnchor.constraint(equalTo: onBoardingButton.widthAnchor),
            pedometerButton.heightAnchor.constraint(equalTo: onBoardingButton.heightAnchor),
            
            nowTimeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nowTimeButton.bottomAnchor.constraint(equalTo: pedometerButton.topAnchor, constant: -20),
            nowTimeButton.widthAnchor.constraint(equalTo: onBoardingButton.widthAnchor),
            nowTimeButton.heightAnchor.constraint(equalTo: onBoardingButton.heightAnchor),
        ])
    }
    
    private func setupButton(_ button: UIButton, title: String, action: Selector) {
        button.setTitle(title, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    @objc private func handleNowTimeTapped() {
        let timeNowVC = TimeNowViewController()
        navigationController?.pushViewController(timeNowVC, animated: true)
    }
    
    @objc private func handlePedometerTapped() {
        
    }
    
    @objc private func navigateToOnBoarding() {
        
    }
}
