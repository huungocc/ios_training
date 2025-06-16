import UIKit
import Kingfisher

class MovieCell: UITableViewCell {

    static let identifier = "MovieCell"

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        return imageView
    }()

    private let titleLabel = MovieCell.makeLabel(fontSize: 17, weight: .medium, color: UIColor(hex: "#EEEEEE")!, lines: 2)
    
    private let ratingLabel = MovieCell.makeLabel(fontSize: 14, weight: .medium, color: UIColor(hex: "#FF8700")!)
    private let categoryLabel = MovieCell.makeLabel(fontSize: 14, weight: .regular, color: UIColor(hex: "#EEEEEE")!)
    private let yearLabel = MovieCell.makeLabel(fontSize: 14, weight: .regular, color: UIColor(hex: "#EEEEEE")!)
    private let runtimeLabel = MovieCell.makeLabel(fontSize: 14, weight: .regular, color: UIColor(hex: "#EEEEEE")!)
    
    private let categoryStack: UIStackView
    private let ratingStack: UIStackView
    private let yearStack: UIStackView
    private let runtimeStack: UIStackView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.categoryStack = MovieCell.makeIconLabelStackView(imageName: "Ticket", label: categoryLabel)
        self.ratingStack = MovieCell.makeIconLabelStackView(imageName: "Star", label: ratingLabel)
        self.yearStack = MovieCell.makeIconLabelStackView(imageName: "Calendar", label: yearLabel)
        self.runtimeStack = MovieCell.makeIconLabelStackView(imageName: "Clock", label: runtimeLabel)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor(hex: "#242A32")
        selectionStyle = .none

        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingStack)
        contentView.addSubview(categoryStack)
        contentView.addSubview(yearStack)
        contentView.addSubview(runtimeStack)

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),

            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            ratingStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            categoryStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryStack.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),

            yearStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            yearStack.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),

            runtimeStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            runtimeStack.topAnchor.constraint(equalTo: yearStack.bottomAnchor, constant: 4),
        ])
    }

    func configure(title: String, rating: String, category: String, year: String, runtime: String, posterURL: String) {
        titleLabel.text = title
        categoryLabel.text = category
        ratingLabel.text = rating
        yearLabel.text = year
        runtimeLabel.text = runtime

        if let url = URL(string: posterURL) {
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = nil
        }
    }

    private static func makeLabel(fontSize: CGFloat, weight: UIFont.Weight, color: UIColor, lines: Int = 1) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = color
        label.numberOfLines = lines
        return label
    }

    private static func makeIconLabelStackView(imageName: String, label: UILabel) -> UIStackView {
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
}
