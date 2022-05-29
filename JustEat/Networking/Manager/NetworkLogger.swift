//
//  NetworkLogger.swift
//  JustEat
//
//  Created by Hassaan Fayyaz Ahmed on 5/30/22.
//

import Foundation

public protocol NetworkLogger {
   func log(request: URLRequest)
   func log(responseData data: Data?, response: URLResponse?)
   func log(error: Error)
}

// MARK: - Logger
//
public final class DefaultNetworkLogger: NetworkLogger {

   public init() { }

   public func log(request: URLRequest) {
       print("-------------")
       print("request: \(request.url!)")
       print("headers: \(request.allHTTPHeaderFields!)")
       print("method: \(request.httpMethod!)")
       if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
           printIfDebug("body: \(String(describing: result))")
       } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
           printIfDebug("body: \(String(describing: resultString))")
       }
   }

   public func log(responseData data: Data?, response: URLResponse?) {
       guard let data = data, data.count < 1024*8*100  else { return }
       if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
           printIfDebug("responseData: \(String(describing: dataDict))")
       }
   }

   public func log(error: Error) {
       printIfDebug("\(error)")
   }
}

func printIfDebug(_ string: String) {
   #if DEBUG
   print(string)
   #endif
}
