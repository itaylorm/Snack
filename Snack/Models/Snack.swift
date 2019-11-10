//
//  Snack.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/8/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import Foundation

// Represents a kind of food
struct Snack: Codable {
  
  // Unique identifier
  let id: UUID
  
  // Display name for the food
  let name: String
  
  // Unique identifier for the food type
  let snackTypeId: UUID
  
  /// Provides mapping between the field name in
  /// returned data from database and the struct name
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case name = "Name"
    case snackTypeId = "SnackTypeId"
  }
  
}
