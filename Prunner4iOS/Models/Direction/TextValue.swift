//
//  TextValue.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/15.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation
import ObjectMapper

public class TextValue: Mappable {
  public var text: String!
  public var value: Int!
  
  required public init?(map: Map) {
  }
  
  public func mapping(map: Map) {
    self.text <- map["text"]
    self.value <- map["value"]
  }
}

public class Distance: TextValue {
}

public class Duration: TextValue {
}
