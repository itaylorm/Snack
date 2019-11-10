//
//  SnackTests.swift
//  SnackTests
//
//  Created by Taylor Maxwell on 11/9/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import XCTest
@testable import Snack

class SnackTests: XCTestCase {

  override func setUp() {
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  /// Ensure that passed values in Snack are appropriately set in SnackViewModel
  func testSnackViewModel() {
    
    let snack = Snack(id: UUID.init(), name: "Test Snack", snackTypeId: Constants.nonVeggieId)
    let snackViewModel = SnackViewModel(snack)
    
    XCTAssertEqual(snack.id, snackViewModel.id)
    XCTAssertEqual(snack.name, snackViewModel.name)
    XCTAssertEqual(snack.snackTypeId, snackViewModel.snackTypeId)
    XCTAssertEqual(UIColor.red, snackViewModel.textColor)
    
    XCTAssertEqual("", snackViewModel.checkedText)
    
    snackViewModel.selected = true
    XCTAssertEqual("√", snackViewModel.checkedText)
  }

}
