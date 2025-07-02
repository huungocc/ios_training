import UIKit

class OnBoardingViewController: UIViewController, UIScrollViewDelegate {
    private let headerView = CustomHeaderView()
    
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
    
    private var backgroundColors: [UIColor] = []
    private var pageViews: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundColors()
        setupInitialBackground()
        setupScrollView()
        setupHeaderView()
        setupPages()
        setupControls()
    }
    
    private func setupBackgroundColors() {
        backgroundColors = jsonArray.compactMap { item in
            guard let hexColor = item["bgColor"] else { return nil }
            return UIColor(hex: hexColor)
        }
    }
    
    private func setupInitialBackground() {
        if !backgroundColors.isEmpty {
            view.backgroundColor = backgroundColors[0]
        }
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
            
            pageView.backgroundColor = .clear
            
            pageViews.append(pageView)
            
            pageView.alpha = i == 0 ? 1.0 : 0.0
            
            scrollView.addSubview(pageView)
            
            NSLayoutConstraint.activate([
                pageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                pageView.widthAnchor.constraint(equalTo: view.widthAnchor),
                pageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(i) * view.frame.width),
                pageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
            ])
            
            // Image view
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            if let imageName = jsonArray[i]["image"] {
                imageView.image = UIImage(named: imageName)
            }
            imageView.translatesAutoresizingMaskIntoConstraints = false
            pageView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
                imageView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: pageView.safeAreaLayoutGuide.topAnchor, constant: 70),
                imageView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.6),
                imageView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.6)
            ])
            
            if i == 0 {
                pageControl.translatesAutoresizingMaskIntoConstraints = false
                pageControl.numberOfPages = jsonArray.count
                pageControl.currentPage = 0
                pageControl.currentPageIndicatorTintColor = .black
                pageControl.pageIndicatorTintColor = .lightGray
                view.addSubview(pageControl)
                
                NSLayoutConstraint.activate([
                    pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    pageControl.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 70)
                ])
            }
            
            // Text stack
            let textStack = UIStackView()
            textStack.translatesAutoresizingMaskIntoConstraints = false
            textStack.axis = .vertical
            textStack.distribution = .fill
            textStack.spacing = 20
            textStack.alignment = .center
            
            pageView.addSubview(textStack)
            
            NSLayoutConstraint.activate([
                textStack.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
                textStack.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20),
                textStack.leadingAnchor.constraint(greaterThanOrEqualTo: pageView.leadingAnchor, constant: 40),
                textStack.trailingAnchor.constraint(lessThanOrEqualTo: pageView.trailingAnchor, constant: -40)
            ])
            
            // Title
            let title = UILabel()
            title.text = jsonArray[i]["bigTitle"]
            title.textColor = .black
            title.font = UIFont.boldSystemFont(ofSize: 28)
            title.textAlignment = .center
            title.numberOfLines = 0
            
            textStack.addArrangedSubview(title)
            
            // Sub title
            let subtitle = UILabel()
            subtitle.text = jsonArray[i]["smallTitle"]
            subtitle.textColor = .darkGray
            subtitle.font = UIFont.systemFont(ofSize: 16)
            subtitle.textAlignment = .center
            subtitle.numberOfLines = 0
            
            textStack.addArrangedSubview(subtitle)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(jsonArray.count), height: view.frame.height)
    }
    
    private func setupControls() {
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
        let currentOffset = scrollView.contentOffset.x
        let pageWidth = view.frame.width
        
        // Tính toán page hiện tại và tỷ lệ scroll
        let currentPageFloat = currentOffset / pageWidth
        let currentPageIndex = Int(floor(currentPageFloat))
        let nextPageIndex = Int(ceil(currentPageFloat))
        let progress = currentPageFloat - floor(currentPageFloat)
        
        // Cập nhật page control
        let roundedPageIndex = Int(round(currentPageFloat))
        if roundedPageIndex != pageControl.currentPage && roundedPageIndex < jsonArray.count {
            pageControl.currentPage = roundedPageIndex
        }
        
        // Thực hiện fade theo thời gian thực
        updatePagesAlpha(currentIndex: currentPageIndex, nextIndex: nextPageIndex, progress: Float(progress))
        updateBackgroundColor(currentIndex: currentPageIndex, nextIndex: nextPageIndex, progress: Float(progress))
        
        // Cập nhật button visibility
        let isLastPage = roundedPageIndex == jsonArray.count - 1
        nextButton.isHidden = isLastPage
        skipButton.isHidden = isLastPage
        startButton.isHidden = !isLastPage
    }
    
    private func updatePagesAlpha(currentIndex: Int, nextIndex: Int, progress: Float) {
        guard currentIndex >= 0 && currentIndex < pageViews.count else { return }
        
        // Reset tất cả alpha về 0
        for pageView in pageViews {
            pageView.alpha = 0.0
        }
        
        // Set alpha cho page hiện tại
        pageViews[currentIndex].alpha = CGFloat(1.0 - progress)
        
        // Set alpha cho page tiếp theo (nếu có)
        if nextIndex < pageViews.count && nextIndex != currentIndex {
            pageViews[nextIndex].alpha = CGFloat(progress)
        }
    }
    
    private func updateBackgroundColor(currentIndex: Int, nextIndex: Int, progress: Float) {
        guard currentIndex >= 0 && currentIndex < backgroundColors.count else { return }
        
        let currentColor = backgroundColors[currentIndex]
        
        if nextIndex < backgroundColors.count && nextIndex != currentIndex {
            let nextColor = backgroundColors[nextIndex]
            
            // Pha giữa 2 màu
            let interpolatedColor = interpolateColor(from: currentColor, to: nextColor, progress: CGFloat(progress))
            view.backgroundColor = interpolatedColor
        } else {
            view.backgroundColor = currentColor
        }
    }
    
    private func interpolateColor(from: UIColor, to: UIColor, progress: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0, fromGreen: CGFloat = 0, fromBlue: CGFloat = 0, fromAlpha: CGFloat = 0
        var toRed: CGFloat = 0, toGreen: CGFloat = 0, toBlue: CGFloat = 0, toAlpha: CGFloat = 0
        
        from.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        to.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let red = fromRed + (toRed - fromRed) * progress
        let green = fromGreen + (toGreen - fromGreen) * progress
        let blue = fromBlue + (toBlue - fromBlue) * progress
        let alpha = fromAlpha + (toAlpha - fromAlpha) * progress
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func addShadow(to button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 6
        button.layer.masksToBounds = false
    }
}
