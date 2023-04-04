//
//  HotelsTaskTests.swift
//  HotelsTaskTests
//
//  Created by Aleksandar Nikolic on 1.4.23..
//

import XCTest
@testable import HotelsTask

class HotelsTaskTests: XCTestCase, HotelsSearchProtocol {
  
  var client = API.mockAPIClient
  let viewModel = HotelListViewModel()
  
  func dataFetched() {
    viewModel.sortBy(.recommended)
  }
  
  func dataSorted() {
    print(viewModel.hotels)
    let sortedRecommendedHighest = viewModel.hotelsCellModel.sorted(by: {$0.recommended > $1.recommended})

    let highestRecommendation = sortedRecommendedHighest.first!.recommended
    let lowestRecommendation = sortedRecommendedHighest.last!.recommended

    let firstElementRecommendation = viewModel.hotelsCellModel.first!.recommended
    let lastElementRecommendation = viewModel.hotelsCellModel.last!.recommended
    
    XCTAssertEqual(firstElementRecommendation, highestRecommendation)
    XCTAssertEqual(lastElementRecommendation, lowestRecommendation)
  }
  
  func showError(_ error: Error) {
    
  }
  
  func startLoader() {
    
  }
  
  func stopLoader(isPullToRefresh: Bool) {
    
  }
  
  func insertNewElements(_ newElements: [HotelCellModel]) {
    
  }
  
  func enableSearchInput(_ enable: Bool) {
    
  }
  
  func testExample2() {
    viewModel.delegate = self
    viewModel.client = client
    viewModel.loadData()
  }

}
