//
//  Hotel.swift
//  HotelsTask
//
//  Created by Aleksandar Nikolic on 1.4.23..
//

import Foundation
import MapKit

struct HotelRoot: Decodable {
  
  let hotelData: HotelData
  
  private enum CodingKeys: String, CodingKey {
    case hotelData = "hotels"
  }
}

struct HotelData: Decodable {

  var hotels: [Hotel] = []
  
  private struct DynamicCodingKeys: CodingKey {
    
    var stringValue: String
    init?(stringValue: String) {
      self.stringValue = stringValue
    }

    var intValue: Int?
    init?(intValue: Int) {
      return nil
    }
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
    var tempArray = [Hotel]()
    
    for key in container.allKeys {
      let decodedObject = try container.decode(Hotel.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
      tempArray.append(decodedObject)
    }
    hotels = tempArray
  }

}

struct Hotel: Decodable {
  let id: Int
  let name: HotelName
  let starRating: Int?
  let thumbnailUrl: URL?
  let price: Int?
  let address: Address
  let recommended: Double
  let distance: Double
  let longitude: Double
  let latitude: Double
  
  private enum CodingKeys: String, CodingKey {
    case id = "atgHotelId"
    case name
    case starRating
    case thumbnailUrl
    case price
    case address
    case recommended = "priorityScore"
    case distance
    case longitude
    case latitude
  }
  
}

struct HotelName: Decodable {
  let en: String
  let ar: String
}

struct Address: Decodable {
  let en: String?
  let ar: String?
}
