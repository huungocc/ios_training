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
    
    private let mainInfoStackView: UIStackView = {
        let stackView  = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    let cardInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()

    private let titleLabel = CustomView.makeLabel(fontSize: 17, weight: .medium, color: UIColor(hex: "#EEEEEE")!)
    
    private let ratingLabel = CustomView.makeLabel(fontSize: 14, weight: .medium, color: UIColor(hex: "#FF8700")!)
    private let categoryLabel = CustomView.makeLabel(fontSize: 14, weight: .regular, color: UIColor(hex: "#EEEEEE")!)
    private let yearLabel = CustomView.makeLabel(fontSize: 14, weight: .regular, color: UIColor(hex: "#EEEEEE")!)
    private let runtimeLabel = CustomView.makeLabel(fontSize: 14, weight: .regular, color: UIColor(hex: "#EEEEEE")!)
    
    private let categoryStack: UIStackView
    private let ratingStack: UIStackView
    private let yearStack: UIStackView
    private let runtimeStack: UIStackView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.categoryStack = CustomView.makeIconLabelStackView(imageName: "Ticket", label: categoryLabel)
        self.ratingStack = CustomView.makeIconLabelStackView(imageName: "Star", label: ratingLabel)
        self.yearStack = CustomView.makeIconLabelStackView(imageName: "Calendar", label: yearLabel)
        self.runtimeStack = CustomView.makeIconLabelStackView(imageName: "Clock", label: runtimeLabel)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor(hex: "#242A32")
        selectionStyle = .none

        [ratingStack, categoryStack, yearStack, runtimeStack].forEach{
            cardInfoStackView.addArrangedSubview($0)
        }
        
        [titleLabel, cardInfoStackView].forEach{
            mainInfoStackView.addArrangedSubview($0)
        }
        
        [posterImageView, mainInfoStackView].forEach{
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            mainInfoStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            mainInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainInfoStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
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
}
