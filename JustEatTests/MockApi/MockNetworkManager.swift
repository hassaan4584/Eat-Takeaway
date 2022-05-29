//
//  MockNetworkManager.swift
//  JustEatTests
//
//  Created by Hassaan Fayyaz Ahmed on 5/22/22.
//

import Foundation
@testable import JustEat

struct MockNetworkManager: NetworkManagerProtocol {

    private let session: URLSession
    private let logger: NetworkLogger

    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        // setting custom protocol classes for mocking api data
        config.protocolClasses = [MockURLProtocol.self]
        self.session = URLSession(configuration: config)
        self.logger = DefaultNetworkLogger()

    }
    init(session: URLSession, logger: NetworkLogger) {
        self.session = session
        self.logger = logger
    }

    @discardableResult
    func makeCall<T: Codable> (withEndPoint endpoint: Endpoint, _ completion: @escaping (Result<T, NetworkError>) -> Void) -> URLSessionDataTask {
        let request = self.createRequest(with: endpoint)
        self.logger.log(request: request)
        return self.request(with: request) { result in
            switch result {
            case .success((let response, let data)):
                self.logger.log(responseData: data, response: response)
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
        }!
    }

    /// make network request with the given request
    @discardableResult
    func request(with urlRequest: URLRequest, _ result: ResultClosure?) -> URLSessionDataTask? {

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
