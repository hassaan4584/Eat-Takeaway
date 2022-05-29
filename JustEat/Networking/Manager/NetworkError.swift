//
//  NetworkError.swift
//  JustEat
//
//  Created by Hassaan Fayyaz Ahmed on 5/30/22.
//

import Foundation

// MARK: - Network Error
public enum NetworkError: Error {
case error(statusCode: Int, data: Data?)
case noInternet
case cancelled
case generic(Error)
case urlGeneration
case emptyData

/// The error message to be shown to user
var errorMessageStr: String {
    switch self {
    case .error(let statusCode, _):
        return "Error Code: \(statusCode)"
    case .noInternet:
        return "No internet connection"
    case .cancelled:
        return "Request cancelled"
    case .generic(let error):
        return "\(error.localizedDescription)"
    case .urlGeneration:
        return "Unable to create url"
    case .emptyData:
        return "No data received"
    }
}
}
