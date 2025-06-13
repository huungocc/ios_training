import UIKit

class OnBoardingViewController: UIViewController, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    
    private var jsonArray: [[String: String]] = [
        ["image": "img1", "bigTitle": "Track your work and get the result", "smallTitle": "Remember to keep track of your professional accomplishments.", "bgColor": "#DAD3C8"],
        ["image": "img2", "bigTitle": "Stay organized with team", "smallTitle": "But understanding the contributions our colleagues make to our teams and companies", "bgColor": "#FFE5DE"],
        ["image": "img3", "bigTitle": "Get notified when work happens", "smallTitle": "Take control of notifications, collaborate live or on your own time", "bgColor": "#DCF6E6"]
    ]
    
    private let skipButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    private let startButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupPages()
        setupControls()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupPages() {
        for i in 0..<jsonArray.count {
            let pageView = UIView()
            pageView.translatesAutoresizingMaskIntoConstraints = false
            
            // BGColor
            if let hexColor = jsonArray[i]["bgColor"] {
                pageView.backgroundColor = UIColor(hex: hexColor)
            }
            
            scrollView.addSubview(pageView)
            
            NSLayoutConstraint.activate([
                pageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                pageView.widthAnchor.constraint(equalTo: view.widthAnchor),
                pageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(i) * view.frame.width),
                pageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
            ])
            
            // Stack
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.distribution = .fill
            stack.spacing = 50
            stack.alignment = .center
            
            pageView.addSubview(stack)
            
            NSLayoutConstraint.activate([
                stack.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
                stack.safeAreaLayoutGuide.topAnchor.constraint(equalTo: pageView.safeAreaLayoutGuide.topAnchor, constant: 50),
                stack.leadingAnchor.constraint(greaterThanOrEqualTo: pageView.leadingAnchor, constant: 40),
                stack.trailingAnchor.constraint(lessThanOrEqualTo: pageView.trailingAnchor, constant: -40)
            ])
            
            // Image view
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            if let imageName = jsonArray[i]["image"] {
                imageView.image = UIImage(named: imageName)
            }
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.6),
                imageView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.6)
            ])
            
            stack.addArrangedSubview(imageView)
            
            // Title
            let title = UILabel()
            title.text = jsonArray[i]["bigTitle"]
            title.textColor = .black
            title.font = UIFont.boldSystemFont(ofSize: 28)
            title.textAlignment = .center
            title.numberOfLines = 0
            
            stack.addArrangedSubview(title)
            
            // Sub title
            let subtitle = UILabel()
            subtitle.text = jsonArray[i]["smallTitle"]
            subtitle.textColor = .darkGray
            subtitle.font = UIFont.systemFont(ofSize: 16)
            subtitle.textAlignment = .center
            subtitle.numberOfLines = 0
            
            stack.addArrangedSubview(subtitle)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(jsonArray.count), height: view.frame.height)
    }
    
    private func setupControls() {
        // Page control
        pageControl.numberOfPages = jsonArray.count
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
        
        // Skip
        skipButton.setTitle("Skip", for: .normal)
        skipButton.tintColor = .black
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            skipButton.widthAnchor.constraint(equalToConstant: 100),
            skipButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Next
        nextButton.setTitle("Next", for: .normal)
        nextButton.tintColor = .white
        nextButton.backgroundColor = .black
        nextButton.layer.cornerRadius = 25
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        addShadow(to: nextButton)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.widthAnchor.constraint(equalToConstant: 100),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Start
        startButton.setTitle("Start", for: .normal)
        startButton.tintColor = .white
        startButton.backgroundColor = .black
        startButton.layer.cornerRadius = 25
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        startButton.isHidden = true
        addShadow(to: startButton)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startButton.widthAnchor.constraint(equalToConstant: 300),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func skipTapped() {
        scrollToPage(index: jsonArray.count - 1)
    }
    
    @objc private func nextTapped() {
        let nextIndex = min(pageControl.currentPage + 1, jsonArray.count - 1)
        scrollToPage(index: nextIndex)
    }
    
    @objc private func startTapped() {
        print("Start button tapped!")
    }
    
    private func scrollToPage(index: Int) {
        let offset = CGPoint(x: CGFloat(index) * view.frame.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / view.frame.width))
        pageControl.currentPage = pageIndex
        
        let isLastPage = pageIndex == jsonArray.count - 1
        nextButton.isHidden = isLastPage
        skipButton.isHidden = isLastPage
        startButton.isHidden = !isLastPage
    }
    
    func addShadow(to button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 6
        button.layer.masksToBounds = false
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
