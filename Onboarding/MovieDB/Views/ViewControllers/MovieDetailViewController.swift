import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var ratingStackView = makeIconLabelStackView(imageName: "Star", label: ratingLabel)
    private lazy var yearStackView = makeIconLabelStackView(imageName: "Calendar", label: yearLabel)
    private lazy var runtimeStackView = makeIconLabelStackView(imageName: "Clock", label: runtimeLabel)
    private lazy var genreStackView = makeIconLabelStackView(imageName: "Ticket", label: genreLabel)
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Thumb")
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let backDropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Background")
        return imageView
    }()
    
    private let titleLabel = MovieDetailViewController.makeLabel(
        title: "Spider-Man: No Way Home",
        fontSize: 24,
        weight: .medium,
        color: .white,
        lines: 2
    )
    
    private let ratingLabel = MovieDetailViewController.makeLabel(
        title: "4.5",
        fontSize: 16,
        weight: .regular,
        color: .systemYellow
    )
    
    private let yearLabel = MovieDetailViewController.makeLabel(
        title: "2019",
        fontSize: 16,
        weight: .regular,
        color: .lightGray
    )
    
    private let runtimeLabel = MovieDetailViewController.makeLabel(
        title: "145",
        fontSize: 16,
        weight: .regular,
        color: .lightGray
    )
    
    private let genreLabel = MovieDetailViewController.makeLabel(
        title: "Action",
        fontSize: 16,
        weight: .regular,
        color: .lightGray
    )
    
    private let overviewLabel = MovieDetailViewController.makeLabel(
        title: "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government, undertaking high-risk black ops missions in exchange for commuted prison sentences.",
        fontSize: 16,
        weight: .regular,
        color: .white,
        lines: 20
    )
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Detail"
        view.backgroundColor = UIColor(hex: "#242A32")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarkButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [yearStackView, makeVerticalSeparator(), runtimeStackView, makeVerticalSeparator(), genreStackView].forEach {
            infoStackView.addArrangedSubview($0)
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let ratingCard = wrapInBlurCard(ratingStackView)
        
        [backDropImageView, posterImageView, titleLabel, ratingCard, infoStackView, overviewLabel].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // BackDrop
            backDropImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backDropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backDropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            //Poster
            posterImageView.centerYAnchor.constraint(equalTo: backDropImageView.bottomAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: backDropImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Info Stack
            infoStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 25),
            infoStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Rating
            ratingCard.bottomAnchor.constraint(equalTo: backDropImageView.bottomAnchor, constant: -16),
            ratingCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            overviewLabel.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 25),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private static func makeLabel(title: String, fontSize: CGFloat, weight: UIFont.Weight, color: UIColor, lines: Int = 1) -> UILabel {
        let label = UILabel()
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = color
        label.numberOfLines = lines
        return label
    }
    
    private func makeIconLabelStackView(imageName: String, label: UILabel) -> UIStackView {
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
    
    private func makeVerticalSeparator() -> UIView {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .lightGray
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: 1),
            separator.heightAnchor.constraint(equalToConstant: 16)
        ])
        return separator
    }
    
    private func wrapInBlurCard(_ stackView: UIStackView) -> UIView {
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

}
