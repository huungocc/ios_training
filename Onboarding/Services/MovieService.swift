import Foundation

final class MovieService {
    func fetchMovieList() async throws -> [MovieModel] {
        let response: MovieListResponse = try await NetworkManager.shared.request(endpoint: "/movie/popular")
        return response.results
    }
    
    func fetchMovieDetails(for movieIds: [Int]) async -> [MovieModel] {
        await withTaskGroup(of: MovieModel?.self) { group in
            var resultModels: [MovieModel] = []
            
            for id in movieIds {
                group.addTask {
                    return try? await self.fetchSingleMovieDetail(id: id)
                }
            }
            
            for await result in group {
                if let movie = result {
                    resultModels.append(movie)
                }
            }
            
            return resultModels
        }
    }
    
    private func fetchSingleMovieDetail(id: Int) async throws -> MovieModel {
        try await NetworkManager.shared.request(endpoint: "/movie/\(id)")
    }
    
    func loadFullMovieList() async throws -> [MovieModel] {
        do {
            let summaries = try await fetchMovieList()
            let ids = summaries.map { $0.id }
            let fullModels = await fetchMovieDetails(for: ids)
            return fullModels
        } catch {
            print("Failed to load full movie list: \(error)")
            throw error
        }
    }
}
