//
//  SnackViewModel.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/9/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import UIKit

// Represents values and settings used to populate snack row
class SnackViewModel {
  
  // Unique identifier
  let id: UUID
  
  // Display name for the food
  let name: String
  
  // Unique identifier for the food type
  let snackTypeId: UUID
  
  var _selected: Bool
  
  // Indicates user has selected this snack
  var selected: Bool {
    get {
      return _selected
    }
    set {
      _selected = newValue
      
      if selected {
        checkedText = "√"
      } else {
        checkedText = ""
      }
    }
  }
  
  // Display text to show in checked next to name
  internal private(set) var checkedText: String
  
  // Indicates what color to display cell text in
  internal private(set) var textColor: UIColor
  
  /// Set up values taken from passed snack
  /// - Parameter snack: associated snack from database
  init(_ snack: Snack) {
    
    self.id = snack.id
    self.name = snack.name
    self.snackTypeId = snack.snackTypeId

    checkedText = ""
    _selected = false
    
    switch(snackTypeId) {
      case Constants.veggieId: textColor = Constants.darkGreenColor
      case Constants.nonVeggieId: textColor = UIColor.red
      default: textColor = Constants.darkGreenColor
    }

  }
  
}
