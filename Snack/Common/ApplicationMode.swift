//
//  ApplicationMode.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/8/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import Foundation

// Used to represent which kind of settings to use
// This allows developer to switch back and forth between
// back end systems with a simple change of which mode
enum ApplicationMode {

  // Production settings active
  case production

  // Test settings active
  case test

  // Development settings active
  case development
  
  // Currently not talking with services
  // Functional with canned data
  case mock
  
}
