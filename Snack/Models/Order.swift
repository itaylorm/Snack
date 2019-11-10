//
//  Order.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/8/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import Foundation

// A snack order
struct Order: Encodable {
  
  // Unique identifier
  let id: Int
  
  // Associated user unique identifier
  let userId: UUID
  
  // Order date time
  let date: Date
  
  // Associated order items
  let items: [OrderLine]
  
  // Tax Paid
  let tax: Decimal
  
  // Sub total
  let total: Decimal
  
  init(id: Int, userId: UUID, date: Date, items: [OrderLine], tax: Decimal, total: Decimal) {
    self.id = id
    self.userId = userId
    self.date = date
    self.items = items
    self.tax = tax
    self.total = total
  }
  
  /// Provides mapping between the field name in
  /// returned data from database and the struct name
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case userId = "UserId"
    case date = "Date"
    case items = "Items"
    case tax = "Tax"
    case total = "Total"
  }
  
}
