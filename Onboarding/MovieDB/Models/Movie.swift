import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    let runtime: Int?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    var posterURL: String {
        return "https://image.tmdb.org/t/p/w500\(posterPath ?? "")"
    }
    
    var year: String {
        return String(releaseDate.prefix(4))
    }
    
    var ratingString: String {
        return String(format: "%.1f", voteAverage)
    }
    
    var runtimeString: String {
        guard let runtime = runtime else { return "" }
        return "\(runtime) minutes"
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}
