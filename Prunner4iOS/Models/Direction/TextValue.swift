//
//  TextValue.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/15.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation
import ObjectMapper

public class TextValue: NSObject, NSCoding, Mappable {
  public var text: String!
  public var value: Int!
  
  required public init?(map: Map) {
  }
  
  public func mapping(map: Map) {
    self.text <- map["text"]
    self.value <- map["value"]
  }
  
  public required init?(
    text: String!,
    value: Int!
    ){
    self.text = text
    self.value = value
  }
  
  required convenience public init?(coder aDecoder: NSCoder) {
    let text = aDecoder.decodeObject(forKey: "text") as! String!
    let value = aDecoder.decodeObject(forKey: "value") as! Int!
    
    self.init(
      text: text,
      value: value
    )
  }
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(text, forKey: "text")
    aCoder.encode(value, forKey: "value")
  }
}

public class Distance: TextValue {
}

public class Duration: TextValue {
}
