//
//  GMPlaceRequest.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/16.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation
import ObjectMapper
import APIKit

public class GMPlaceRequest: GMBaseRequest {
  public typealias Response = [Place]
  
  public var queryParameters: [String: AnyObject] = [:]
  
  public var method: HTTPMethod {
    return .get
  }
  
  //なぜbaseURLを再定義しなくてはいけないのか...Swiftに詳しい人よろしく
  public var baseURL: URL {
    return URL(string: "https://maps.googleapis.com/maps/api/")! as URL
  }
  
  public var path: String = "place/"
  
  public func intercept(urlRequest: URLRequest) throws -> URLRequest {
    let parameterString = self.queryParameters.stringFromHttpParameters()
    let requestURL = URL(string:(urlRequest.url?.absoluteString)! + "?" + parameterString)!
    return URLRequest(url: requestURL)
  }
  
  public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> GMPlaceRequest.Response {
    let mapper = Mapper<Response.Element>()
    guard let dictionary = object as? [String: Any],
      let results = dictionary["results"] as? [Any],
      let response = mapper.mapArray(JSONObject: results) else {
        throw ResponseError.unexpectedObject(object)
    }
    return response
  }
  
  public static func NearBySearch() -> GMPlaceRequest {
    let new = GMPlaceRequest()
    new.path = new.path + "nearbysearch/json"
    return new
  }
}
