import UIKit

class CustomView {
    static func makeIconLabelStackView(imageName: String, label: UILabel) -> UIStackView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true

        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    static func makeLabel(title: String? = nil, fontSize: CGFloat, weight: UIFont.Weight, color: UIColor, lines: Int = 1) -> UILabel {
        let label = UILabel()
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = color
        label.numberOfLines = lines
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = false
        return label
    }
    
    static func makeVerticalSeparator() -> UIView {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .lightGray
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: 1),
            separator.heightAnchor.constraint(equalToConstant: 16)
        ])
        return separator
    }
    
    static func wrapInBlurCard(_ stackView: UIStackView) -> UIView {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 12
        blurView.clipsToBounds = true

        blurView.contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 6),
            stackView.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -6),
            stackView.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -10)
        ])

        return blurView
    }
    
    static func setupButton(_ button: UIButton, title: String, titleColor: UIColor, bgColor: UIColor, borderWidth: CGFloat? = nil, borderColor: CGColor? = nil, action: Selector, target: Any?) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        if let borderWidth = borderWidth {
            button.layer.borderWidth = borderWidth
        }
        if let borderColor = borderColor {
            button.layer.borderColor = borderColor
        }
        button.addTarget(target, action: action, for: .touchUpInside)
    }
}
