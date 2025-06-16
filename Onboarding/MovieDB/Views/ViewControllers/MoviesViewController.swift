import UIKit
import Kingfisher

class MoviesViewController: UIViewController {
    
    private let tableView = UITableView()
    
    // Dữ liệu cứng, không model
    private let titles = ["Inception", "Interstellar", "The Dark Knight"]
    private let ratings = ["8.8", "8.6", "9.0"]
    private let years = ["2010", "2014", "2008"]
    private let runtimes = ["148 minutes", "169 minutes", "152 minutes"]
    private let category = ["Action", "Adventure", "Action"]
    private let posterURLs = [
        "https://image.api.playstation.com/vulcan/img/rnd/202011/0714/At7kpPioyCSPENS5x6gHesjR.png",
        "https://image.api.playstation.com/vulcan/img/rnd/202011/0714/At7kpPioyCSPENS5x6gHesjR.png",
        "https://image.api.playstation.com/vulcan/img/rnd/202011/0714/At7kpPioyCSPENS5x6gHesjR.png"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#242A32")
        title = "Movies"
        navigationController?.navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor.white
        ]

        setupTableView()
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.configure(
            title: titles[indexPath.row],
            rating: ratings[indexPath.row],
            category: category[indexPath.row],
            year: years[indexPath.row],
            runtime: runtimes[indexPath.row],
            posterURL: posterURLs[indexPath.row]
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = MovieDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
