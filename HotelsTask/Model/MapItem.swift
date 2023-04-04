//
//  MapItem.swift
//  HotelsTask
//
//  Created by Aleksandar Nikolic on 3.4.23..
//

import Foundation
import MapKit

class MapItem: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var subtitle: String?
  var title: Int?
  
  init(coordinate: CLLocationCoordinate2D, price: Int?, name: String) {
    self.subtitle = name
    self.title = price
    self.coordinate = coordinate
  }
}
