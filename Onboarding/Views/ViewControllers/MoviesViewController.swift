import UIKit
import Kingfisher

class MoviesViewController: UIViewController {
    private let headerView = CustomHeaderView()
    
    private var moviesViewModel = MoviesViewModel()
    private let tableView = UITableView()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#242A32")
        
        setupHeaderView()
        
        setupTableView()
        setupProgressHUD()
        
        Task {
            await loadMoviesData()
        }
    }
    
    private func setupHeaderView() {
        navigationController?.isNavigationBarHidden = true
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.configure(title: "Movies", bgColor: .clear, colorTitle: .white, backButtonColor: .white)
        
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
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(hex: "#242A32")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupProgressHUD() {
        view.addSubview(loadingView)
        loadingView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }
    
    @MainActor
    private func showProgressHUD() {
        loadingView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    @MainActor
    private func hideProgressHUD() {
        loadingView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func loadMoviesData() async {
        showProgressHUD()
        
        await moviesViewModel.loadMovies()
        
        await MainActor.run {
            tableView.reloadData()
        }
        
        hideProgressHUD()
    }
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesViewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = moviesViewModel.movies[indexPath.row]
        
        cell.configure(
            title: movie.title,
            rating: String(format: "%.1f", movie.voteAverage),
            category: movie.genres?.map { $0.name }.joined(separator: ", ") ?? "",
            year: movie.releaseDate,
            runtime: "\(movie.runtime ?? 0) minutes",
            posterURL: "https://image.tmdb.org/t/p/w500\(movie.posterPath)"
        )	
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = moviesViewModel.movies[indexPath.row]
        let detailVC = MovieDetailViewController()
        detailVC.movie = movie
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
