//
//  OrderViewController.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/10/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import UIKit
import RxSwift

/// Provides a way to communication between add order
/// and the main controller
protocol OrderDelegate {
  
  /// Triggers when order added
  /// - Parameter order: new order id
  func didAddOrder(id: Int)
  
  /// Indicates order add failed
  func didAddOrderFailure()
  
}

/// Handles displaying order selections to user and allowing
/// him or her to complete the order
class OrderViewController: UIViewController {
  
  private let orderCellIdentifier = "OrderCell"
  
  // Currently displayed snacks
  var snackViewModels = [SnackViewModel]()
  
  private var disposeBag = DisposeBag()
  
  var orderDelegate: OrderDelegate?
  
  @IBOutlet weak var tableView: UITableView!
  
  /// Initial Load
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // https://medium.com/@hacknicity/view-controller-presentation-changes-in-ios-13-ac8c901ebc4e
    if #available(iOS 13.0, *) {
      self.isModalInPresentation = true
    } else {
      // Needs no change
    }
    
    // Configures view controller to know about the custom row cell
    let cellNib = UINib(nibName: orderCellIdentifier, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier:orderCellIdentifier)
    
    // Configures service class(es) to point to the correct
    // web services (Development, Test, Production, OR mock data)
    if Setting.instance.mode != ApplicationMode.mock {
      OrderService.Initialize(service: Service())
    } else {
      OrderService.Initialize(service: OrderMock())
    }
    
    tableView.reloadData()
    
  }
  
  /// Handles the pressing of submit button
  /// - Parameter sender: reference to submit button
  @IBAction func submitOrder(sender: UIButton) {
    
    // Assemble order information
    var lines = [OrderLine]()
    for snackModel in self.snackViewModels {
      lines.append(OrderLine(id: UUID.init(), orderId: 0, snackId: snackModel.id, quantity: 1, price: 0.0, subTotal: 0.0))
    }
    
    let order = Order(id: 0, userId: Constants.blankUUIDFromString, date: Date(), items: lines, tax: 0.0, total: 0.0)
    self.addOrder(order)
    
  }
  
  
  /// Sends order to cloud
  /// - Parameter order: order to send
  private func addOrder(_ order: Order) {
  
    _ = OrderService.instance.add(order: order)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { result in
        
        self.dismiss(animated: true, completion: nil)
        
        if result.success && result.id != 0 {
          
          self.orderDelegate?.didAddOrder(id: result.id)
          
        } else {

          self.orderDelegate?.didAddOrderFailure()
          
        }
        
      },
     onError: { error in
        Logger.error(error.localizedDescription)
        self.dismiss(animated: true, completion: nil)
      
        self.orderDelegate?.didAddOrderFailure()
      
      },
     onCompleted: {
        Logger.debug("Order completed.")
      })
      .disposed(by: disposeBag)
    
  }
  
  /// Cancels the order add and takes user back to the original screen
  /// - Parameter sender: Reference to cancel button
  @IBAction func cancelOrder(sender: UIButton) {
    
    self.dismiss(animated: true, completion: nil)
    
  }
  
}

// Handles all table operations
extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
  
  /// Returns the number of rows found in the associated array
  /// - Parameters:
  ///   - tableView: Reference to current table view
  ///   - section: Section Name (If any)
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return snackViewModels.count
    
  }
  
  /// Populates a row in the table with associated data
  /// - Parameters:
  ///   - tableView: reference to current table view
  ///   - indexPath: row number in the table view
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: orderCellIdentifier, for: indexPath) as! OrderCell
    
    cell.snackViewModel = snackViewModels[indexPath.row]
    
    return cell
    
  }
}
