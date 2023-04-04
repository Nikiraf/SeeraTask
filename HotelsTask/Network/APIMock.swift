//
//  APIMock.swift
//  HotelsTask
//
//  Created by Aleksandar Nikolic on 4.4.23..
//

import Foundation

enum TestValidation: Error {
  case failedToLoadTestData(URL)
}

extension API {
  static let mockAPIClient = API { url in
    guard let data = MockResponses(url: url)?.data else {
      throw TestValidation.failedToLoadTestData(url)
    }
    return data
  }
}

private enum MockResponses {
  case hotelsEndpoint
  
  init?(url: URL) {
    switch url.absoluteString {
    case Constants.serverUrl:
      self = .hotelsEndpoint
    default:
      return nil
    }
  }
  
  var fileName: String {
    switch self {
    case .hotelsEndpoint:
      return "HotelsMock"
    }
  }
  
  var data: Data? {
    Bundle.main.path(forResource: fileName, ofType: "json").flatMap { path in
      let fileURL = URL(fileURLWithPath: path)
      return try? Data(contentsOf: fileURL, options: .mappedIfSafe)
    }
  }
  
}
