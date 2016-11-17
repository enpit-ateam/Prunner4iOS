//
//  Base.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/15.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation
import APIKit
import ObjectMapper

extension String {
  func addingPercentEncodingForURLQueryValue() -> String? {
    let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
    return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
  }
}

extension Dictionary {
  func stringFromHttpParameters() -> String {
    let parameterArray = self.map { (key, value) -> String in
      let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
      let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
      return "\(percentEscapedKey)=\(percentEscapedValue)"
    }
    return parameterArray.joined(separator: "&")
  }
}

public protocol GMBaseRequest: Request {
}

public extension GMBaseRequest where Self.Response: Mappable {
  public var baseURL: URL {
    return URL(string: "https://maps.googleapis.com/maps/api/")! as URL
  }
  
  public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
    let mapper = Mapper<Response>()
    guard let dictionary = object as? [String: Any],
      let response = mapper.map(JSON: dictionary) else {
        throw ResponseError.unexpectedObject(object)
    }
    return response
  }
}
