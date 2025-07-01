import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {
    private let headerView = CustomHeaderView()
    
    private var isMark = false
    
    var movie: MovieModel?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var ratingStackView = CustomView.makeIconLabelStackView(imageName: "Star", label: ratingLabel)
    private lazy var yearStackView = CustomView.makeIconLabelStackView(imageName: "Calendar", label: yearLabel)
    private lazy var runtimeStackView = CustomView.makeIconLabelStackView(imageName: "Clock", label: runtimeLabel)
    private lazy var genreStackView = CustomView.makeIconLabelStackView(imageName: "Ticket", label: genreLabel)
    
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
    
    private let titleLabel = CustomView.makeLabel(
        fontSize: 24,
        weight: .medium,
        color: .white,
        lines: 2
    )
    
    private let ratingLabel = CustomView.makeLabel(
        fontSize: 16,
        weight: .regular,
        color: .systemYellow
    )
    
    private let yearLabel = CustomView.makeLabel(
        fontSize: 16,
        weight: .regular,
        color: .lightGray
    )
    
    private let runtimeLabel = CustomView.makeLabel(
        fontSize: 16,
        weight: .regular,
        color: .lightGray
    )
    
    private let genreLabel = CustomView.makeLabel(
        fontSize: 16,
        weight: .regular,
        color: .lightGray
    )
    
    private let overviewLabel = CustomView.makeLabel(
        fontSize: 16,
        weight: .regular,
        color: .white,
        lines: 20
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView()
        setupUI()
        bindData()
    }
    
    private func setupHeaderView() {
        navigationController?.isNavigationBarHidden = true
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.configure(title: "Details", bgColor: .clear, colorTitle: .white, backButtonColor: .white)
        headerView.setSuffixButton(suffixIcon: UIImage(systemName: "bookmark"), suffixColor: .white, showSuffixButton: true)
        
        headerView.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        headerView.onSuffixTapped = { [weak self] in
            guard let self = self else { return }
            self.isMark.toggle()
            self.headerView.setSuffixButton(suffixIcon: UIImage(systemName: isMark ? "bookmark.fill" : "bookmark"), suffixColor: .white, showSuffixButton: true)
        }

        view.addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func bindData() {
        guard let movie = movie else { return }
        
        titleLabel.text = movie.title
        ratingLabel.text = String(format: "%.1f", movie.voteAverage)
        yearLabel.text = String(movie.releaseDate.prefix(4))
        runtimeLabel.text = "\(movie.runtime ?? 0) minutes"
        genreLabel.text = movie.genres?.first?.name ?? ""
        overviewLabel.text = movie.overview
        posterImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)"))
        backDropImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.backdropPath)"))
    }
    
    private func setupUI() {
        title = "Detail"
        view.backgroundColor = UIColor(hex: "#242A32")
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [yearStackView, CustomView.makeVerticalSeparator(), runtimeStackView, CustomView.makeVerticalSeparator(), genreStackView].forEach {
            infoStackView.addArrangedSubview($0)
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let ratingCard = CustomView.wrapInBlurCard(ratingStackView)
        
        [backDropImageView, posterImageView, titleLabel, ratingCard, infoStackView, overviewLabel].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
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
            backDropImageView.heightAnchor.constraint(equalToConstant: 210),
            	
            //Poster
            posterImageView.centerYAnchor.constraint(equalTo: backDropImageView.bottomAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            
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
}
