//
//  Api.swift
//  HotelsTask
//
//  Created by Aleksandar Nikolic on 1.4.23..
//

import Foundation

typealias LoadHotelsResult = Result<[Hotel], Error>

enum ServerError: Error {
  case noResponseData
  case invalidUrl
}

private let decoder = JSONDecoder()

extension API {
  static let liveClient = API { url in
    let request = URLRequest(url: url)
    
    return try await URLSession.shared.data(for: request).0
  }
  
  func loadHotels(_ completion: @escaping (Result<[Hotel], Error>) -> Void) {
    guard let url = URL(string: Constants.serverUrl) else {
      completion(.failure(ServerError.invalidUrl))
      return
    }
    Task {
      do {
        let data = try await self.fetchData(url)
        let decoded = try decoder.decode(HotelRoot.self, from: data)
        completion(.success(decoded.hotelData.hotels))
      } catch {
        completion(.failure(error))
      }
    }
  }
  
}

struct API {
  var fetchData: (URL) async throws -> Data

  init(fetchData: @escaping (URL) async throws -> Data) {
    self.fetchData = fetchData
  }
  
  
}
