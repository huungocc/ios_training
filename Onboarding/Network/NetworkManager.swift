import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
    case unknown
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "b6089aedb1274752de2f1022865a15ac"

    func request<T: Decodable>(
        endpoint: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> T {
        var components = URLComponents(string: baseURL + endpoint)
        var finalQueryItems = queryItems
        finalQueryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        components?.queryItems = finalQueryItems

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        print("Requesting: \(url.absoluteString)")

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                print("Decoding error: \(error)")
                throw NetworkError.decodingError
            }

        } catch {
            throw NetworkError.serverError(error.localizedDescription)
        }
    }
}
