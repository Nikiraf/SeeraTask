//
//  HotelListViewModel.swift
//  HotelsTask
//
//  Created by Aleksandar Nikolic on 1.4.23..
//

import Foundation
import UIKit
import MapKit

protocol HotelsSearchProtocol: AnyObject {
  func dataFetched()
  func dataSorted()
  func showError(_ error: Error)
  func startLoader()
  func stopLoader(isPullToRefresh: Bool)
  func insertNewElements(_ newElements: [HotelCellModel])
  func enableSearchInput(_ enable: Bool)
}

class HotelListViewModel {
  
  weak var delegate: HotelsSearchProtocol?
  
  var client: API = API.liveClient
  
  let numberOfNewElementThatWillBeLoaded: Int = 20
  var totalNumberOfElementsThatWillBeLoaded: Int = 0
  let loadNewElementOffsetIndex: Int = 5
  var currentIndex: Int = 0
  
  var isSearchActive: Bool = false
  
  private var newHotelsForAppending: [HotelCellModel] = []
  
  // Keeps all data that will be used in Hotel tablew view
  private var originalHotelsCellModel: [HotelCellModel] = []
  
  // Keep original data that are fetched from the API
  private (set) var hotels: [Hotel] = []
  
  // Part of data that is used in tableView. When search or sort is performed
  private (set) var hotelsCellModel: [HotelCellModel] = []
  
  func loadData(isPullToRefresh: Bool = false) {
    if !isPullToRefresh {
      self.delegate?.startLoader()
    }
    self.delegate?.enableSearchInput(false)
    client.loadHotels { [weak self] result in
      guard let self = self else {
        return
      }
      self.delegate?.stopLoader(isPullToRefresh: isPullToRefresh)
      switch result {
      case .failure(let error):
        self.delegate?.showError(error)
      case .success(let hotels):
        self.delegate?.enableSearchInput(true)
        self.hotels = hotels
        self.makeHotelCellModel()
        self.populateModelWithNewData()
      }
    }
  }
  
  private func makeHotelCellModel() {
    originalHotelsCellModel.removeAll()
    for hotel in hotels {
      let name = Language.currentLanguage == .ar ? hotel.name.ar : hotel.name.en
      let rating = hotel.starRating ?? 0
      let thumbnailUrl = hotel.thumbnailUrl
      let price = hotel.price
      let address = Language.currentLanguage == .ar ? hotel.address.ar ?? "" : hotel.address.en ?? ""
      let recomended = hotel.recommended
      let distance = hotel.distance
      let longitude = hotel.longitude
      let latitude = hotel.latitude
      
      let newHotel = HotelCellModel(name: name, starRating: rating, thumbnailUrl: thumbnailUrl, price: price, address: address, recommended: recomended, distance: distance, longitude: longitude, latitude: latitude)
      
      originalHotelsCellModel.append(newHotel)
    }
  }
//  Model that is used for map screen.
//  We can also check if latitude and longitude is available and skip the ones that doesn't have long or lat
  func makeHotelMapItem() -> [MapItem] {
    var mapHotels: [MapItem] = []
    for hotel in hotelsCellModel {
      let cordinate = CLLocationCoordinate2D(latitude: hotel.latitude, longitude: hotel.longitude)
      let mapHotel = MapItem(coordinate: cordinate, price: hotel.price, name: hotel.name)
      mapHotels.append(mapHotel)
    }
    return mapHotels
  }
  
  // Sorting function can be moved in external class so we can reuse it in the other parts of the app if it is needed in the future
  func sortBy(_ sortBy: SortRepositoryBy) {
    switch sortBy {
    case .recommended:
      hotelsCellModel = hotelsCellModel.sorted(by: {$0.recommended > $1.recommended})
    case .lowestPrice:
      hotelsCellModel = hotelsCellModel.sorted(by: {$0.price ?? 99999999999999 < $1.price ?? 99999999999999})
    case .starRating:
      hotelsCellModel = hotelsCellModel.sorted(by: {$0.starRating > $1.starRating})
    case .distance:
      hotelsCellModel = hotelsCellModel.sorted(by: {$0.distance < $1.distance})
    }
    
    delegate?.dataSorted()
  }
  
  func findHotelsByName(_ query: String) {
    isSearchActive = !query.isEmpty
    guard !query.isEmpty else {
      hotelsCellModel = originalHotelsCellModel
      return
    }
    let tmpHotels = originalHotelsCellModel.filter({$0.name.lowercased().contains(query.lowercased())})
    hotelsCellModel = tmpHotels
  }
  
  // This part can and should be improved
  func populateModelWithNewData() {
    // Covering the case when number of fetched hotels from API is less then our set number which is 20
    if isSearchActive || hotelsCellModel.count >= originalHotelsCellModel.count {
      return
    }
    if (totalNumberOfElementsThatWillBeLoaded == 0) || (currentIndex == totalNumberOfElementsThatWillBeLoaded - loadNewElementOffsetIndex) {
      // If number of new hotels that we want to append is less then avaialble number of hotels, then we append all of the hotels that is left
      if originalHotelsCellModel.count < numberOfNewElementThatWillBeLoaded {
        totalNumberOfElementsThatWillBeLoaded = originalHotelsCellModel.count
      }else {
        totalNumberOfElementsThatWillBeLoaded += numberOfNewElementThatWillBeLoaded
      }
      // Adding tmpArray beacause we have didSet on hotelsCellModel that will be triggered on every set
//      var tmpArray: [HotelCellModel] = hotelsCellModel
      newHotelsForAppending.removeAll()
//      print("hotelsCellModel.count: \(hotelsCellModel.count)")
//      print("totalNumberOfElementsThatWillBeLoaded: \(totalNumberOfElementsThatWillBeLoaded)")
      for i in hotelsCellModel.count..<totalNumberOfElementsThatWillBeLoaded {
        hotelsCellModel.append(originalHotelsCellModel[i])
        newHotelsForAppending.append(originalHotelsCellModel[i])
      }
      if totalNumberOfElementsThatWillBeLoaded <= 20 {
        delegate?.dataFetched()
      }else {
        delegate?.insertNewElements(newHotelsForAppending)
      }
    }
  }
  
}
