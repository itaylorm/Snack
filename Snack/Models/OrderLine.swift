//
//  OrderLine.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/8/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import Foundation

struct OrderLine: Encodable {
  
  // Unique identifier
  let id: UUID
  
  // Associated order
  let orderId: Int
  
  // Associated snack unique identifier
  let snackId: UUID
  
  // Quantity
  let quantity: Int
  
  // Associated price
  let price: Decimal
  
  // Sub total
  let subTotal: Decimal
  
  /// Provides mapping between the field name in
  /// returned data from database and the struct name
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case snackId = "SnackId"
    case quantity = "Quantity"
    case price = "Price"
    case subTotal = "SubTotal"
  }
  
}
