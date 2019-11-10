//
//  Result.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/9/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import Foundation

/// Provides the response to a web service call including returned data
struct Result : Codable {
  
  // The outcome: True: Success, False: Failure
  var success: Bool = false
  
  // Response message back from service
  var message: String?
  
  // Returned data
  var data: String?
  
  // Generated Id
  var id: Int
  
  /// Provides mapping between the field name in
  /// returned data from database and the struct name
  enum CodingKeys: String, CodingKey {
    case success = "Success"
    case message = "Message"
    case data = "Data"
    case id = "id"
  }
  
  /**
   * Custom to string for printing to console
   * @return string representation of object
   */
  public func toString() -> String {
    return "Result{" +
      "success= \(success) '\n'" +
      "message= \(message ?? "") '\n'" +
      "data= \(data ?? "") '\n'" +
      "id= \(id) '\n'" +
    "'}'"
  }
  
}
