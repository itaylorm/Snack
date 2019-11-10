//
//  Formatter.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/8/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import Foundation

// Handles issues with formatting dates
// Original Idea from this link: https://useyourloaf.com/blog/swift-codable-with-custom-dates/
extension Formatter {
  
  // Handles normal dates with subseconds
  static let iso8601: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    return formatter
  }()
  
  // Handles dates with no sub seconds
  // Notice the missing.SSS
  static let missingSS: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return formatter
  }()
  
  /// Takes a date string and returns as date
  /// - Parameter dateString: date string to be converted
  static func stringToDate(dateString: String) -> Date {
    
    if dateString.contains(".") {
      
      if let date = Formatter.iso8601.date(from: dateString) as Date? {
        return date
      }
      
    } else {
      
      if let date = Formatter.missingSS.date(from: dateString) as Date? {
        return date
      }
      
    }
    
    return Date(timeIntervalSince1970: 0)
    
  }
  
}
