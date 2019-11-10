//
//  User.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/8/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import Foundation

struct User {
  
  // Unique Identifier
  let id: UUID
  
  // Unique name for user for login
  let userName: String
  
  // User type unique identifier
  let userTypeId: UUID
  
  // Associated email address
  let emailAddress: String
  
  // User first name
  let firstName: String
  
  // User middle name
  let middleName: String
  
  // User last name
  let lastName: String
  
  /// Provides mapping between the field name in
  /// returned data from database and the struct name
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case userName = "UserName"
    case userTypeId = "UserTypeId"
    case emailAddress = "EmailAddress"
    case firstName = "FirstName"
    case middleName = "MiddleName"
    case lastName = "LastName"
  }
  
}
