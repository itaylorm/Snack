//
//  OrderMock.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/10/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import UIKit
import RxCocoa
import Alamofire
import RxSwift
import SwiftyJSON

// Contains the common methods and properties for simulating working with web services
class OrderMock: ServiceProtocol {
  
  // Common serializer and deserializer
  let jsonEncoder = JSONEncoder()
  let jsonDecoder = JSONDecoder()
  
  private static var orderNumber: Int = 0
  
  init() {
    
    jsonEncoder.dateEncodingStrategy = .formatted(Formatter.iso8601)
    jsonDecoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
    
  }
  
  /// Handles making a post call without a security token
  /// - Parameter pathComponent: The part of a url that is unique to a call
  func buildGetRequest(pathComponent: String) -> Observable<JSON> {
   
    let result: Observable<JSON> = Observable.create() { observer in
      observer.onCompleted()
      return Disposables.create()
    }
    return result
   
  }
  
  /// Handles making a web service put call
  /// - Parameters:
  ///   - pathComponent: The part of a url that is unique to a call
  ///   - postData: Data to be sent to the web service
  func buildPutRequest(pathComponent: String, postData: Data) -> Observable<JSON> {
    
    let result: Observable<JSON> = Observable.create() { observer in
      observer.onCompleted()
      return Disposables.create()
    }
    return result
    
  }
  
  /// Handles making a web service post call
  /// - Parameters:
  ///   - pathComponent: The part of a url that is unique to a call
  ///   - postData: Data to be posted to the web service
  func BuildPostRequest(pathComponent: String, postData: Data) -> Observable<JSON> {
    
    
    let resultJson: Observable<JSON> = Observable.create() { observer in

      do {

        OrderMock.orderNumber += 1
        let result = Result(success: true, message: "Success", data: JSON(postData).rawString(), id: OrderMock.orderNumber)
        let resultEncoded = try self.jsonEncoder.encode(result)
        let resultJson = JSON(resultEncoded)
        observer.onNext(resultJson)
        observer.onCompleted()
        
      } catch let error {
        Logger.error(error.localizedDescription)
        observer.onNext(JSON())
        observer.onCompleted()
      }
      
      return Disposables.create()
      
    }
    
    return resultJson
    
  }
  
}
