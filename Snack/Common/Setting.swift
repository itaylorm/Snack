//
//  Setting.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/8/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import Foundation

/// Represents the base collection of urls and settings for web services
class Setting {
  
  static let productionBaseUrl: String = "http://services.localhost.com/api/"
  static let developmentBaseUrl: String = "http://devservices.localhost.com/api/"

  /// Shared reference for accessing application settings
  static var instance = Setting()
  
  /// Configure web service Urls
  /// - Parameter mode: mode associated with current web service settings
  static func Initialize(mode: ApplicationMode) {
    
    instance = Setting(mode: mode)
    
  }
  
  ///Configure application settings based upon mode
  /// @mode: Application mode which defines the urls and settings to use
  private init(mode: ApplicationMode = ApplicationMode.development) {
    
    self.mode = mode
    
    var baseUrl: String
    switch mode {
    case .production:
      baseUrl = Setting.productionBaseUrl
      
    case .development:
      baseUrl = Setting.developmentBaseUrl
    case .mock:
      baseUrl = ""
    default:
      baseUrl = Setting.developmentBaseUrl;
      
    }
    
    snackUrl = "\(baseUrl)snack"
    snackTypeUrl = "\(baseUrl)snacktype"
    userUrl = "\(baseUrl)user"
    userTypeUrl = "\(baseUrl)usertype"
    orderUrl = "\(baseUrl)order"
    
  }
  
  // Address for the service for for working with snack information
  var snackUrl: String
  
  // Address for the service for for working with snack type information
  var snackTypeUrl: String
  
  // Address for the service for for working with user information
  var userUrl: String
  
  // Address for the service for for working with user type information
  var userTypeUrl: String
  
  // Address for the service for for working with order type information
  var orderUrl: String
  
  // Current application environment or group of settings being used
  var mode: ApplicationMode
  
}
