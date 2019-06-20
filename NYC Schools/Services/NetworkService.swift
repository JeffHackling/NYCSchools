import Foundation

private enum NetworkError: Error {
    case unknownError
    case connectionError
    case invalidCredentials
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case timeOut
    case unsupportedURL
    case emptyResult
}

private enum HTTPVerb: String {
    case GET = "GET"
    case POST = "POST"
}

final class NetworkService {
    
    // MARK: - Properties
    
    fileprivate var session: URLSession!
    
    // MARK: - Initialization
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    init(_ session: URLSession) {
        self.session = session
    }
    
    // MARK: - Endpoint Accessors
    
    func makeRequest<T:Decodable>(url: URL?,
                                  type: T.Type,
                                  params: [String:String]?,
                                  completion: @escaping (T?)->()) {
        guard let url = url else {
            completion(nil)
            return
        }
        get(type: type, url: url, params: params) { (result) in
            switch result {
            case .success(let val):
                completion(val)
            case .failure:
                completion(nil)
            }
        }
    }
    
    // MARK: - Post
    
    private func get<T: Decodable>(type: T.Type,
                                   url: URL,
                                   params: [String:String]?,
                                   completion: @escaping (Result<T, NetworkError>)->()) {
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = params
        urlRequest.httpMethod = "GET"
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let _ = error {
                completion(Result.failure(.connectionError))
                return
            }
            guard let _ = response else {
                completion(Result.failure(.serverError))
                return
            }
            guard let safeData = data else {
                completion(Result.failure(.emptyResult))
                return
            }
            
            guard let value = try? JSONDecoder().decode(T.self, from: safeData) else {
                completion(Result.failure(.invalidResponse))
                return
            }
            completion(Result.success(value))
            }.resume()
    }
}
