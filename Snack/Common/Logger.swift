//
//  Logger.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/9/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import Foundation

typealias LogName = String

// Provides a means to display logs. Different kinds of logs can be enabled and disabled
struct Logger {
  
  // Kind of log allowing different kinds to be disabled as needed
  public enum Level: Int {
    case verbose
    case debug
    case info
    case warning
    case error
    case none
    
    var description: String {
      switch self {
      case .verbose:
        return "-verbose"
      case .debug:
        return "---debug"
      case .info:
        return "----info"
      case .warning:
        return "-warning"
      case .error:
        return "---error"
      case .none:
        return "---None"
      }
    }
  }
  
  // The minimum level to log. Set this to see more or less messages.
  static var level = Level.info
  
  // The date and time format for log messages.
  // - Default: "yyyy-MM-dd HH:mm:ss.SSS"
  static var dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
  
  /// Displays a message
  /// - Parameters:
  ///   - level: kind of log message
  ///   - msg: Text to display
  private static func log(level: Level, msg: String) {
    
    if level.rawValue >= self.level.rawValue {
      let formatter = DateFormatter()
      formatter.dateFormat = dateFormat
      let dateString = formatter.string(from: Date())
      
      print("\(dateString) [Snack] \(level.description) \(msg)")
    }
    
  }
  
  /// Send a message to the verbose logging level
  /// - Parameter message: a string to log
  static func verbose(_ message: String) {
    Logger.log(level: .verbose, msg: message)
  }
  
  /// Send a message to the debug logging level
  /// - Parameter message: a string to log
  static func debug(_ message: String) {
    Logger.log(level: .debug, msg: message);
  }

  /// Send a message to the info logging level
  /// - Parameter message: a string to log
  static func info(_ message: String) {
    Logger.log(level: .info, msg: message);
  }
  
  /// Send a message to the warning logging level
  /// - Parameter message: a string to log
  static func warning(_ message: String) {
    Logger.log(level: .warning, msg: message);
  }
  
  /// Send a message to the error logging level
  /// - Parameter message: a string to log
  static func error(_ message: String) {
    Logger.log(level: .error, msg: message);
  }
  
}
