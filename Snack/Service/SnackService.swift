//
//  SnackService.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/9/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import Foundation
import RxSwift

// Provides means for working with snacks
class SnackService {
  
  // Common serializer and deserializer
  let jsonEncoder = JSONEncoder()
  let jsonDecoder = JSONDecoder()
  
  // Current list of Snacks
  var snacks: BehaviorSubject<[Snack]?> = BehaviorSubject<[Snack]?>(value: nil)
  
  // Shared reference for accessing snack data
  let service: ServiceProtocol
  
  /// Shared reference for accessing application settings
  static var instance = SnackService()
  
  /// Configure web service Urls
  /// - Parameter service: low level service instance
  static func Initialize(service: ServiceProtocol) {
    
    instance = SnackService(service)
    
  }
  
  
  /// Configures class for working with snack web service(s)
  /// - Parameter service: Associated low level service system
  private init(_ service: ServiceProtocol = Service()) {
    
    jsonEncoder.dateEncodingStrategy = .formatted(Formatter.iso8601)
    jsonDecoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
    
    self.service = service
    
  }

  /// Provides means to retrieve snack list
  func get() -> Observable<Result> {

    return service.buildGetRequest(pathComponent: "\(Setting.instance.snackUrl)").map() { json in
     
     do {
       
       let result = try self.jsonDecoder.decode(Result.self, from: json.rawData())
       
       if result.success {
         
         if let jsonString: String = result.data {
           
           let data = jsonString.data(using: .utf8)!
           
           do {
             
             let snacks = try self.jsonDecoder.decode([Snack].self, from: data )
             self.snacks.onNext(snacks)
             return result
             
           } catch let error {
             Logger.error(error.localizedDescription)
            return Result.init(success: false, message: "Unable to deserialize information", data: jsonString, id: 0)
           }
         }
         
         return result
         
       }
       
     } catch let error {
       Logger.error(error.localizedDescription)
      return Result.init(success: false, message: "Unable to read deserialize returned result", data: json.rawString(), id: 0)
     }
     
      return Result.init(success: false, message: "Unable to retrieve returned information", data: "No data", id: 0)
     
    }
  }
}
