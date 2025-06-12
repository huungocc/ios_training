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
        scrollView.frame = view.bounds
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)
        
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(jsonArray.count), height: view.frame.height)
    }
    
    private func setupPages() {
        for i in 0..<jsonArray.count {
            // Page view
            let pageView = UIView(frame: CGRect(x: CGFloat(i) * view.frame.width,
                                                y: 0,
                                                width: view.frame.width,
                                                height: view.frame.height))
            
            // BGColor
            if let hexColor = jsonArray[i]["bgColor"] {
                pageView.backgroundColor = UIColor(hex: hexColor)
            }
            
            // Image view
            let imageWidth = view.frame.width / 1.5
            let imageX = (view.frame.width - imageWidth) / 2
            let imageView = UIImageView(frame: CGRect(x: imageX, y: 100, width: imageWidth, height: imageWidth))
            imageView.contentMode = .scaleAspectFit
            
            if let imageName = jsonArray[i]["image"] {
                imageView.image = UIImage(named: imageName)
            }
            pageView.addSubview(imageView)
            
            // Title
            let title = UILabel(frame: CGRect(x: 20, y: view.frame.height/2, width: view.frame.width - 40, height: 80))
            title.text = jsonArray[i]["bigTitle"]
            title.textColor = .black
            title.font = UIFont.boldSystemFont(ofSize: 30)
            title.textAlignment = .center
            title.numberOfLines = 0
            pageView.addSubview(title)
            
            // Sub title
            let subtitle = UILabel(frame: CGRect(x: 20, y: view.frame.height/2 + 100, width: view.frame.width - 40, height: 80))
            subtitle.text = jsonArray[i]["smallTitle"]
            subtitle.textColor = .darkGray
            subtitle.font = UIFont.systemFont(ofSize: 20)
            subtitle.textAlignment = .center
            subtitle.numberOfLines = 0
            pageView.addSubview(subtitle)
            
            // Page view
            scrollView.addSubview(pageView)
        }
    }
    
    private func setupControls() {
        // Page control
        pageControl.numberOfPages = jsonArray.count
        pageControl.currentPage = 0
        pageControl.frame = CGRect(x: 0, y: view.frame.height - 150, width: view.frame.width, height: 20)
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        view.addSubview(pageControl)
        
        // Skip
        skipButton.setTitle("Skip", for: .normal)
        skipButton.tintColor = .black
        skipButton.frame = CGRect(x: 20, y: view.frame.height - 100, width: 100, height: 50)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        view.addSubview(skipButton)
        
        // Next
        nextButton.setTitle("Next", for: .normal)
        nextButton.tintColor = .white
        nextButton.backgroundColor = .black
        nextButton.layer.cornerRadius = 22
        nextButton.frame = CGRect(x: view.frame.width - 120, y: view.frame.height - 100, width: 100, height: 50)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        addShadow(to: nextButton)
        view.addSubview(nextButton)
        
        // Start
        startButton.setTitle("Start", for: .normal)
        startButton.tintColor = .white
        startButton.backgroundColor = .black
        startButton.layer.cornerRadius = 22
        startButton.frame = CGRect(x: (view.frame.width - 300)/2, y: view.frame.height - 100, width: 300, height: 50)
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        startButton.isHidden = true
        addShadow(to: startButton)
        view.addSubview(startButton)
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

