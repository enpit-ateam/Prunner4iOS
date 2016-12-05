//
//  Locations.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/15.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation
import ObjectMapper

public class Location: NSObject, NSCoding, Mappable {
  public var lat: Double!
  public var lng: Double!
  
  required public init?(map: Map) {
  }
  
  init(lat: Double, lng: Double) {
    self.lat = lat
    self.lng = lng
  }
  
  public func mapping(map: Map) {
    self.lat <- map["lat"]
    self.lng <- map["lng"]
  }
  
  public required init?(
    lat: Double!,
    lng: Double!
  ){
    self.lat = lat
    self.lng = lng
  }
  
  required convenience public init?(coder aDecoder: NSCoder) {
    let lat = aDecoder.decodeObject(forKey: "lat") as! Double!
    let lng = aDecoder.decodeObject(forKey: "lng") as! Double!
    
    self.init(
      lat: lat,
      lng: lng
    )
  }
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(lat, forKey: "lat")
    aCoder.encode(lng, forKey: "lng")
  }
}
