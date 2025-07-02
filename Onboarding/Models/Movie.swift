struct MovieModel: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let backdropPath: String
    let voteAverage: Double
    let runtime: Int?
    let genres: [Genre]?
    let releaseDate: String

    struct Genre: Decodable {
        let name: String
    }

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}

// Response list (dùng lại model trên)
struct MovieListResponse: Decodable {
    let results: [MovieModel]
}
