//
//  UserType.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/8/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import Foundation

// Kind of user (Such as Internal, Customer)
struct UserType {
  
  // Unique identifer
  let id: UUID
  
  // Display name
  let name: String
  
  /// Provides mapping between the field name in
  /// returned data from database and the struct name
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case name = "Name"
  }
  
}
