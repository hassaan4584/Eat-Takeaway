//
//  Endpoint.swift
//  JustEat
//
//  Created by Hassaan Fayyaz Ahmed on 5/22/22.
//

import Foundation

typealias QueryParams = [String: String]
typealias BodyParams = [String: Any]

protocol Endpoint {

    /// The host. for example www.google.com
    var baseURL: URL { get }
    /// `path` of the request
    var path: String { get }
    /// The headers accompnying http request
    var headers: [String: String]? { get }
    /// The `http` method of request
    var httpMethod: String { get }

}
