import Foundation

final class MovieService {
    func fetchMovieList() async throws -> [MovieModel] {
        return try await withCheckedThrowingContinuation { continuation in
            NetworkManager.shared.request(endpoint: "/movie/popular") { (result: Result<MovieListResponse, NetworkError>) in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response.results)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchMovieDetails(for movieIds: [Int]) async -> [MovieModel] {
        await withTaskGroup(of: MovieModel?.self) { group in
            var resultModels: [MovieModel] = []
            
            for id in movieIds {
                group.addTask {
                    return await self.fetchSingleMovieDetail(id: id)
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
    
    private func fetchSingleMovieDetail(id: Int) async -> MovieModel? {
        return await withCheckedContinuation { continuation in
            NetworkManager.shared.request(endpoint: "/movie/\(id)") { (result: Result<MovieModel, NetworkError>) in
                switch result {
                case .success(let detail):
                    continuation.resume(returning: detail)
                case .failure(let error):
                    print("Failed to fetch detail for id \(id): \(error)")
                    continuation.resume(returning: nil)
                }
            }
        }
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
