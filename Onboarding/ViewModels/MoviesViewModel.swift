final class MoviesViewModel {
    private let service = MovieService()
    private(set) var movies: [MovieModel] = []

    func loadMovies() async {
        do {
            let models = try await service.loadFullMovieList()
            await MainActor.run {
                self.movies = models
            }
        } catch {
            print("Failed to load movies: \(error)")
            await MainActor.run {
                self.movies = []
            }
        }
    }
}
