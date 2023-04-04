//
//  MapViewController.swift
//  HotelsTask
//
//  Created by Aleksandar Nikolic on 3.4.23..
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  var hotels: [MapItem] = []
  
  @IBAction func closeControllerAction(_ sender: UIButton) {
    self.dismiss(animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    
    setMapArea()
    addHotelsToMap()
  }
  
  private func setMapArea() {
    // This can be improved by calculating middle value of all coordinates
    guard let centerPin = hotels.first else {
      return
    }
    let region = MKCoordinateRegion(center: centerPin.coordinate, latitudinalMeters: 25000, longitudinalMeters: 25000)
    mapView.setRegion(region, animated: true)
  }
  
  private func addHotelsToMap() {
    for hotel in hotels {
      mapView.addAnnotation(hotel)
    }
  }
}

extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if let item = annotation as? MapItem {
      let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "HotelMapItem")
      ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "HotelMapItem")
      
      annotationView.annotation = item
      annotationView.image = UIImage(systemName: "building.fill")
      annotationView.clusteringIdentifier = "mapItemClustered"
      
      return annotationView
    }else if let cluster = annotation as? MKClusterAnnotation {
      let clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: "clusterView")
      ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "clusterView")
      
      clusterView.annotation = cluster
      clusterView.image = UIImage(systemName: "building.2.fill")
      
      return clusterView
    }else {
      return nil
    }
  }
}
