//
//  Constants.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/8/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import UIKit

class Constants {
  
  static let blankUUIDFromString = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
  
  // Snack Types
  static let veggieId = UUID(uuidString: "dc2c91e5-7f6f-4cff-999e-b4ad25648410")!
  static let nonVeggieId = UUID(uuidString: "52cd992d-d562-41f6-b2f1-ae00156becd1")!
  
  // Dialog Text
  static let servicesUnavailableTitle = "Services Unavailable"
  static let servicesUnavailableMessage = "Please check your internet \r\n connection and try again"
  
  static let orderAddedTitle = "Successfully added order"
  static let orderAddedMessage = "Your order number is: "
  static let orderAddedTitleFailure = "Unable to add order"
  static let orderAddedFailureMessage = "Unable to add order"
  static let mustPickAtLeastOneTitle = "No snacks selected"
  static let mustPickAtLeastOneMessage = "You must pick at least one"
  
  static let darkGreenColor = UIColor(red: CGFloat(47.0/255.0), green: CGFloat(121.0/255.0), blue: CGFloat(47.0/255.0), alpha: 1.0)
}
