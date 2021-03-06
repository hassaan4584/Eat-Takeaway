//
//  NetworkManager.swift
//  JustEat
//
//  Created by Hassaan Fayyaz Ahmed on 5/22/22.
//

import Foundation

typealias ResultClosure = (Result<(URLResponse, Data), Error>) -> Void

// MARK: NetworkManagerProtocol
protocol NetworkManagerProtocol {

    /// This function makes the network call for the passed `Endpoint`
    /// - Returns: The network request of `URLSessionDataTask`
    @discardableResult
    func makeCall<T: Codable> (withEndPoint endpoint: Endpoint, _ completion: @escaping (Result<T, NetworkError>) -> Void) -> URLSessionDataTask
}

extension NetworkManagerProtocol {
    /// Helper function to create a URLRequest object using EndPoint
    func createRequest(with endpoint: Endpoint) -> URLRequest {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var urlRequest = URLRequest.init(url: url)
        urlRequest.allHTTPHeaderFields = endpoint.headers
        urlRequest.httpMethod = endpoint.httpMethod
        return urlRequest
    }
}

// MARK: NetworkManager
struct NetworkManager: NetworkManagerProtocol {

    private let session: URLSession
    private let logger: NetworkLogger

    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: config)
        self.logger = DefaultNetworkLogger()
    }

    /// Custom init function for initializer based dependecy injection
    init(session: URLSession, logger: NetworkLogger) {
        self.session = session
        self.logger = logger
    }

    /// This function makes the network call for the passed `Endpoint`
    /// - Returns: The network request of `URLSessionDataTask`
    @discardableResult
    func makeCall<T: Codable> (withEndPoint endpoint: Endpoint, _ completion: @escaping (Result<T, NetworkError>) -> Void) -> URLSessionDataTask {

        let urlRequest = self.createRequest(with: endpoint)
        self.logger.log(request: urlRequest)
        let urlSessionDataTask = self.request(with: urlRequest) { (result: Result<(URLResponse, Data), Error>) in
            switch result {
            case .success((let response, let data)):
                guard response is HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.emptyData))
                    }
                    return
                }
                do {
                    let decoder = try JSONDecoder.init().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decoder))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.generic(error)))
                    }
                }
            case .failure(let err):
                guard (err as NSError).code != NSURLErrorNotConnectedToInternet else {
                    DispatchQueue.main.async { completion(.failure(NetworkError.noInternet))}
                    return
                }
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.generic(err)))
                }
            }
        }
        return urlSessionDataTask!
    }

    /// Make actual network request witht the given request and send callback with `ResultClosure`
    /// - Parameters:
    ///   - urlRequest: The urlRequest to fetch data from server
    ///   - result: Callback of type Result
    /// - Returns: The network request of `URLSessionDataTask`
    @discardableResult
    private func request(with urlRequest: URLRequest, _ result: ResultClosure?) -> URLSessionDataTask? {

        let task = self.session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                result?(.failure(error))
                return
            }
            guard let response = response, let data = data, !data.isEmpty else {
                let error = NetworkError.emptyData
                result?(.failure(error))
                return
            }
            result?(.success((response, data)))
        }

        task.resume()
        return task
    }
}
