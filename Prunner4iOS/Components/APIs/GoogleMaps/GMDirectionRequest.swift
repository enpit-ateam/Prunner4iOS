//
//  Direction.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/15.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation
import ObjectMapper
import APIKit

public class GMDirectionRequest: GMBaseRequest {
  public typealias Response = Direction
  
  public var queryParameters: [String: AnyObject] = [:]
  
  public var method: HTTPMethod {
    return .get
  }
  
  public var path: String {
    return "directions/json"
  }
  
  public func intercept(urlRequest: URLRequest) throws -> URLRequest {
    let parameterString = self.queryParameters.stringFromHttpParameters()
    let requestURL = URL(string:(urlRequest.url?.absoluteString)! + "?" + parameterString)!
    return URLRequest(url: requestURL)
  }
}
