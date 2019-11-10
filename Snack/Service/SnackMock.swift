//
//  ServiceMock.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/9/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import UIKit
import RxCocoa
import Alamofire
import RxSwift
import SwiftyJSON

// Contains the common methods and properties for simulating working with web services
class SnackMock: ServiceProtocol {
  
  // Common serializer and deserializer
  let jsonEncoder = JSONEncoder()
  let jsonDecoder = JSONDecoder()
  
  
  init() {
    
    jsonEncoder.dateEncodingStrategy = .formatted(Formatter.iso8601)
    jsonDecoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
    
  }
  
  /// Handles making a post call without a security token
  /// - Parameter pathComponent: The part of a url that is unique to a call
  /// - Throws EncodingError.invalidValue when cannot encode properly
  func buildGetRequest(pathComponent: String) -> Observable<JSON> {
   
    let snackJson: Observable<JSON> = Observable.create() { observer in
      
      let snacks = [
        Snack(id: UUID(uuidString: "ad3c1e10-80f3-4636-bb34-8ab1d94b9a23")!, name: "French fries", snackTypeId: Constants.veggieId),
        Snack(id: UUID(uuidString: "f73151d6-d939-4aa4-b516-02aa9862b470")!, name: "Veggieburger", snackTypeId: Constants.veggieId),
        Snack(id: UUID(uuidString: "307480c6-b040-4f97-9cdf-2df1219c5add")!, name: "Carrots", snackTypeId: Constants.veggieId),
        Snack(id: UUID(uuidString: "31269257-66ba-4bbb-9a4e-f1e44dad4372")!, name: "Apple", snackTypeId: Constants.veggieId),
        Snack(id: UUID(uuidString: "a8e461ef-252e-4fea-a6b7-f3f987b68f33")!, name: "Banana", snackTypeId: Constants.veggieId),
        Snack(id: UUID(uuidString: "aac01127-8587-4b48-b03d-ae06c0dac6d1")!, name: "Milkshake", snackTypeId: Constants.veggieId),
        Snack(id: UUID(uuidString: "f9d3c4f2-be36-42de-afd4-77abada6e749")!, name: "Cheeseburger", snackTypeId: Constants.nonVeggieId),
        Snack(id: UUID(uuidString: "034bcf60-d617-4eb3-a170-8c8f0f6b06c2")!, name: "Hamburger", snackTypeId: Constants.nonVeggieId),
        Snack(id: UUID(uuidString: "3361b596-5428-4db6-8a17-07f7edf3090a")!, name: "Hot dog", snackTypeId: Constants.nonVeggieId)
      ]

      do {
        
        let snacksEncoded = try self.jsonEncoder.encode(snacks)
        let dataJson = JSON(snacksEncoded)
        let result = Result(success: true, message: "Success", data: dataJson.rawString(), id: 0)

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
    
    return snackJson
   
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
    
    let result: Observable<JSON> = Observable.create() { observer in
      observer.onCompleted()
      return Disposables.create()
    }
    return result
    
  }
  
}
