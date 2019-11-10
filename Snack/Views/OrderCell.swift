//
//  OrderCell.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/10/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import UIKit

// Represents a single snack on in an order
class OrderCell: UITableViewCell {
  
  @IBOutlet weak var name: UILabel!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
 }

    
  // Associate the view model with the row
  var snackViewModel: SnackViewModel! {
    didSet {
      
      self.name.text = snackViewModel.name
      self.name.textColor = snackViewModel.textColor
      self.name.sizeToFit()
      
    }
  }
  
}
