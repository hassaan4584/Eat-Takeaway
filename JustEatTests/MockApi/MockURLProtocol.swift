//
//  MockURLProtocol.swift
//  JustEatTests
//
//  Created by Hassaan Fayyaz Ahmed on 5/22/22.
//

import Foundation

class MockURLProtocol: URLProtocol {

    /// This will contain the hardcoded response data of given api request
    static var stubResponseData: Data?
    static var stubResponseLinkHeader: [String: String]?
    static var stubResonseStatusCode: Int = 200

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        self.client?.urlProtocol(self, didLoad: MockURLProtocol.stubResponseData ?? Data())

        // Setting empty, but some valid api response object
        let httpResponse = HTTPURLResponse(url: self.request.url!, statusCode: MockURLProtocol.stubResonseStatusCode, httpVersion: "1.0", headerFields: MockURLProtocol.stubResponseLinkHeader)

        if MockURLProtocol.stubResonseStatusCode == 200 {
            self.client?.urlProtocol(self, didReceive: httpResponse!, cacheStoragePolicy: .allowed)
        } else {
            self.client?.urlProtocol(self, didFailWithError: NSError(domain: "Error", code: MockURLProtocol.stubResonseStatusCode))
        }

        // calling `urlProtocolDidFinishLoading` in order to trigger completion handler of api request
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // This needs to be overriden, but it can be empty
    }

}
