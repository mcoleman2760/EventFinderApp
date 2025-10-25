import Foundation

public enum NetworkError: Error {
    case invalidURL
    case badResponse(Int)
    case transport(Error)
    case decoding(Error)
}

public struct Networking: Sendable {  // <-- Added Sendable
    public static let shared = Networking()
    public init() {}

    @available(iOS 15.0, *)
    public func fetch<T: Decodable>(url: URL) async throws -> T {
        var req = URLRequest(url: url)
        req.timeoutInterval = 20

        let (data, response) = try await URLSession.shared.data(for: req)

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.badResponse(-1)
        }
        guard (200..<300).contains(http.statusCode) else {
            throw NetworkError.badResponse(http.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }

   
}
