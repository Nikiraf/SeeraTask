//
//  HotelsTaskTests.swift
//  HotelsTaskTests
//
//  Created by Aleksandar Nikolic on 1.4.23..
//

import XCTest
@testable import HotelsTask

class HotelsTaskTests: XCTestCase {
  
  var client = API.mockAPIClient
  let viewModel = HotelListViewModel()
  
  func testExpectingDataToBeFetched() {
    let expectation = self.expectation(description: "")
    let delegate = TestFetchData {
      expectation.fulfill()
    }
    
    viewModel.delegate = delegate
    viewModel.client = .mockAPIClient
    viewModel.loadData()
    self.waitForExpectations(timeout: 2)
    let expected: [TestFetchData.DelegateEvent] = [.startLoader, .enableSearchInput(false), .stopLoader(isPullToRefresh: false), .enableSearchInput(true), .dataFetched]
    XCTAssertEqual(expected, delegate.events)
    XCTAssertEqual(viewModel.hotelsCellModel.count, 9)
  }

}

class TestFetchData: HotelsSearchProtocol {
  
  enum DelegateEvent: Equatable {
    case dataFetched
    case dataSorted
    case showError(_ error: NSError)
    case startLoader
    case stopLoader(isPullToRefresh: Bool)
    case insertNewElements(_ newElements: [HotelCellModel])
    case enableSearchInput(_ enable: Bool)
  }
  
  let onLoad: () -> Void
  var events: [DelegateEvent] = []
  
  init(onLoad: @escaping () -> Void) {
    self.onLoad = onLoad
  }
  
  func dataFetched() {
    events.append(.dataFetched)
    onLoad()
  }
  
  func dataSorted() {
    events.append(.dataSorted)
  }
  
  func showError(_ error: Error) {
    events.append(.showError(error as NSError))
  }
  
  func startLoader() {
    events.append(.startLoader)
  }
  
  func stopLoader(isPullToRefresh: Bool) {
    events.append(.stopLoader(isPullToRefresh: isPullToRefresh))
  }
  
  func insertNewElements(_ newElements: [HotelCellModel]) {
    events.append(.insertNewElements(newElements))
  }
  
  func enableSearchInput(_ enable: Bool) {
    events.append(.enableSearchInput(enable))
  }
  
}
