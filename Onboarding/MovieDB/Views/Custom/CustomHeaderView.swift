import UIKit

class CustomHeaderView: UIView {
    var onBackTapped: (() -> Void)?
    var onSuffixTapped: (() -> Void)?
    
    let backButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    let suffixButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(nil, for: .normal)
        button.tintColor = .label
        button.isHidden = true
        return button
    }()
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = .label
        title.textAlignment = .center
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(suffixButton)
        
        backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        suffixButton.addTarget(self, action: #selector(handleSuffixTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            suffixButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            suffixButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            suffixButton.widthAnchor.constraint(equalToConstant: 30),
            suffixButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(title: String, bgColor: UIColor? = .systemBackground, colorTitle: UIColor? = .label, showBackButton: Bool? = true, backButtonColor: UIColor? = .label, ) {
        backgroundColor = bgColor
        titleLabel.text = title
        titleLabel.textColor = colorTitle
        backButton.tintColor = backButtonColor
        backButton.isHidden = !showBackButton!
    }
    
    func setSuffixButton(suffixIcon: UIImage? = nil, suffixColor: UIColor? = .label, showSuffixButton: Bool? = false) {
        suffixButton.setImage(suffixIcon, for: .normal)
        suffixButton.tintColor = suffixColor
        suffixButton.isHidden = !showSuffixButton!
    }
    
    @objc private func handleBackTap() {
        onBackTapped?()
    }
    
    @objc private func handleSuffixTap() {
        onSuffixTapped?()
    }
}
