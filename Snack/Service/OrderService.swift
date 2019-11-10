//
//  OrderService.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/10/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import Foundation
import RxSwift

// Provides means for working with orders
class OrderService {
  
  // Common serializer and deserializer
  let jsonEncoder = JSONEncoder()
  let jsonDecoder = JSONDecoder()
  
  // Current list of Snacks
  var order: BehaviorSubject<Order?> = BehaviorSubject<Order?>(value: nil)
  
  // Shared reference for accessing snack data
  let service: ServiceProtocol
  
  /// Shared reference for accessing application settings
  static var instance = OrderService()
  
  /// Configure web service Urls
  /// - Parameter service: low level service instance
  static func Initialize(service: ServiceProtocol) {
    
    instance = OrderService(service)
    
  }
  
  
  /// Configures class for working with snack web service(s)
  /// - Parameter service: Associated low level service system
  private init(_ service: ServiceProtocol = Service()) {
    
    jsonEncoder.dateEncodingStrategy = .formatted(Formatter.iso8601)
    jsonDecoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
    
    self.service = service
    
  }
  
  /// Provides a means to add an assessment associated with an impact
  /// - Parameter order: order to be saved
  func add(order: Order) -> Observable<Result> {
    
    do {
      
      let jsonOrder = try self.jsonEncoder.encode(order)
    
      return service.BuildPostRequest(pathComponent: "\(Setting.instance.orderUrl)/add", postData: jsonOrder).map() { json in
        
        do {
          
          let result = try self.jsonDecoder.decode(Result.self, from: json.rawData())
          return result
          
        } catch let error {
          Logger.error(error.localizedDescription)
          return Result.init(success: false, message: "Unable to read deserialize returned result", data: json.rawString(), id: 0)
        }

      }
      
    } catch let error {
      
      Logger.error(error.localizedDescription)
      
      return Observable.create() { observer in
        
        observer.onNext(Result.init(success: false, message: "Unable to serialize order", data: error.localizedDescription, id: 0))
        observer.onCompleted()
       
        return Disposables.create()
      
      }
      
    }
    
  }

}

//      return service.buildPostRequest(pathComponent: "\(Setting.instance.orderUrl)/add", postData: jsonOrder).map() { json in
//
//        do {
//
//          let result = try self.jsonDecoder.decode(Result.self, from: json.rawData())
//          return result
//
//        } catch let error {
//          AILogger.error(error.localizedDescription)
//          return ResultWithIssues.init(success: false, message: "Unable to read deserialize returned result", data: json.rawString())
//        }
//      }
