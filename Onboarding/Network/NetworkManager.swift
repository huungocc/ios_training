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
        queryItems: [URLQueryItem] = [],
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        var components = URLComponents(string: baseURL + endpoint)
        var finalQueryItems = queryItems
        finalQueryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        components?.queryItems = finalQueryItems

        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }

        print("Requesting: \(url.absoluteString)")

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.serverError("Failed to call API")))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                print("Error: \(error)")
                completion(.failure(.decodingError))
            }
        }

        task.resume()
    }
}
