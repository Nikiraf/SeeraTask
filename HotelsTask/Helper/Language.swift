//
//  Language.swift
//  HotelsTask
//
//  Created by Aleksandar Nikolic on 2.4.23..
//

import Foundation

enum Language {
  
  case en
  case ar
  
  static var currentLanguage: Language {
    switch Locale.preferredLanguages.first!.uppercased() {
    case "AR":
      return .ar
    default:
      return .en
    }
  }
  
}
