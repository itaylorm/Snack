//
//  Service.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/8/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import UIKit
import RxCocoa
import Alamofire
import RxSwift
import SwiftyJSON

// List of possible returned errors for an api call
public enum ApiError: Error {
  case serverFailure
  case invalidKey
  case expiredToken
  case invalidData
}

protocol ServiceProtocol {
  
  /// Handles making a post call without a security token
  /// - Parameter pathComponent: The part of a url that is unique to a call
  func buildGetRequest(pathComponent: String) -> Observable<JSON>
  
  /// Handles making a web service put call
  /// - Parameters:
  ///   - pathComponent: The part of a url that is unique to a call
  ///   - postData: Data to be sent to the web service
  func buildPutRequest(pathComponent: String, postData: Data) -> Observable<JSON>
  
  /// Handles making a web service post call
  /// - Parameters:
  ///   - pathComponent: The part of a url that is unique to a call
  ///   - postData: Data to be posted to the web service
  func BuildPostRequest(pathComponent: String, postData: Data) -> Observable<JSON>
  
}

// Contains the common methods and properties for working with web services
class Service: ServiceProtocol {
  
  // Common serializer and deserializer
  let jsonEncoder = JSONEncoder()
  let jsonDecoder = JSONDecoder()
  
  
  init() {
    
    jsonEncoder.dateEncodingStrategy = .formatted(Formatter.iso8601)
    jsonDecoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
    
  }
  
  /// Handles making a post call without a security token
  /// - Parameter pathComponent: The part of a url that is unique to a call
  func buildGetRequest(pathComponent: String) -> Observable<JSON> {
   
   let request: Observable<URLRequest> = Observable.create() { observer in
     
     let url = URL(string: pathComponent)!
     let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
     
     var request = URLRequest(url: url)
     request.url = urlComponents.url!
     
     request.httpMethod = HTTPMethod.get.rawValue
     request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
     
     observer.onNext(request)
     observer.onCompleted()
     
     return Disposables.create()
     
   }
   
   return ProcessRequest(request: request)
   
  }
  
  /// Handles making a web service put call
  /// - Parameters:
  ///   - pathComponent: The part of a url that is unique to a call
  ///   - postData: Data to be sent to the web service
  func buildPutRequest(pathComponent: String, postData: Data) -> Observable<JSON> {
    
    let request: Observable<URLRequest> = Observable.create() { observer in
      
      let url = URL(string: pathComponent)!
      var request = URLRequest(url: url)
      request.httpMethod = HTTPMethod.put.rawValue
      request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
      request.httpBody = postData
      
      observer.onNext(request)
      observer.onCompleted()
      
      return Disposables.create()
      
    }
    
    return ProcessRequest(request: request)
    
  }
  
  /// Handles making a web service post call
  /// - Parameters:
  ///   - pathComponent: The part of a url that is unique to a call
  ///   - postData: Data to be posted to the web service
  func BuildPostRequest(pathComponent: String, postData: Data) -> Observable<JSON> {
    
    let request: Observable<URLRequest> = Observable.create() { observer in
      
      let url = URL(string: pathComponent)!
      var request = URLRequest(url: url)
      request.httpMethod = HTTPMethod.post.rawValue
      request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
      request.httpBody = postData
      
      observer.onNext(request)
      observer.onCompleted()
      
      return Disposables.create()
      
    }
    
    return ProcessRequest(request: request)
    
  }
  
  /// low level function to handle communication with web service
  /// - Parameter request: assembled web service details to send
  private func ProcessRequest(request: Observable<URLRequest>) -> Observable<JSON> {
    
    let session = URLSession.shared
    
    return request.flatMap() { request in
      
      return session.rx.response(request: request).map() { response, data in
        
        if 200 ..< 300 ~= response.statusCode {
          
          do {
            return try JSON(data: data)
          } catch {
            throw ApiError.invalidData
          }
          
        } else if response.statusCode == 401 {
          throw ApiError.invalidKey
        } else {
          throw ApiError.serverFailure
        }
        
      }
    }
    
  }
  
}
