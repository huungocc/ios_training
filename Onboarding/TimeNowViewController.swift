import UIKit

class TimeNowViewController: UIViewController {
    private let clockTitle = UILabel()
    
    var timer: Timer?
    var currentTime: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(clockTitle)
        
        clockTitle.translatesAutoresizingMaskIntoConstraints = false
            clockTitle.textColor = .black
            clockTitle.font = UIFont.systemFont(ofSize: 40, weight: .medium)
            clockTitle.textAlignment = .center
            
        NSLayoutConstraint.activate([
            clockTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clockTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            clockTitle.widthAnchor.constraint(equalToConstant: 200),
            clockTitle.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        getTimeNow()
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }
    
    func getTimeNow() {
        currentTime = Date()
        self.updateTimeLabel()
    }
    
    @objc func updateTime() {
        currentTime = currentTime.addingTimeInterval(1)
        updateTimeLabel()
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
