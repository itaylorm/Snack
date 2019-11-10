//
//  ViewController.swift
//  Snack
//
//  Created by Taylor Maxwell on 11/8/19.
//  Copyright © 2019 Taylor Maxwell. All rights reserved.
//

import UIKit
import RxSwift

/// Provides a way to communication between add snack
/// and the main controller
protocol SnackDelegate {
  
  func didAddSnack()
  
}

/// Main controller for Snack
class MainViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var veggieSwitch: UISwitch!
  @IBOutlet weak var nonVeggieSwitch: UISwitch!
  @IBOutlet weak var submitButton: UIButton!
  
  // Unique Identifier for the custom cell for the grid, see in views group
  private var snackCellIdentifier = "SnackCell"
  
  private var segueOrder = "showOrder"
  
  // All current snacks
  private var allSnackViewModels = [SnackViewModel]()
  
  // Currently displayed snacks
  private var snackViewModels = [SnackViewModel]()
  
  // Filter settings for returned snacks
  private var includeVeggies = true
  private var includeNonVeggies = true
  
  private var disposeBag = DisposeBag()
  
  /// Initial Load
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // https://medium.com/@hacknicity/view-controller-presentation-changes-in-ios-13-ac8c901ebc4e
    if #available(iOS 13.0, *) {
      self.modalPresentationStyle = UIModalPresentationStyle.fullScreen
      self.isModalInPresentation = true
    } else {
      // Needs no change
    }
    
    // Configures view controller to know about the custom row cell
    let cellNib = UINib(nibName: snackCellIdentifier, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier:snackCellIdentifier)
    
    // Configures configuration settings to the current urls or the mock
    Setting.Initialize(mode: ApplicationMode.mock)
    
    // Configures service class(es) to point to the correct
    // web services (Development, Test, Production, OR mock data)
    if Setting.instance.mode != ApplicationMode.mock {
      SnackService.Initialize(service: Service())
    } else {
      SnackService.Initialize(service: SnackMock())
    }
    
    getSnacks()
    
  }
  
  /// Triggers displaying add snack dialog so user can add a new one
  /// - Parameter sender: Reference to triggering button
  @IBAction func addSnack(sender: UIButton) {
    
  }
  
  /// Triggers displaying order details
  /// - Parameter sender: Reference to triggering button
  @IBAction func submitOrder(Sender: UIButton) {
    
    let selectedSnacks = self.snackViewModels.filter { return $0.selected }
    if selectedSnacks.count > 0 {
      
      performSegue(withIdentifier: segueOrder, sender: self)
      
    } else {
      
      let alert = UIAlertController(title: Constants.mustPickAtLeastOneTitle,
                                    message: Constants.mustPickAtLeastOneMessage, preferredStyle: .alert)
      
      let actionOk = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        
        alert.dismiss(animated: true, completion: nil)
        
      }
      alert.addAction(actionOk)
      self.present(alert, animated: true, completion: nil)
    }

  }
  
  /*
   * Handles passing selected cue information to firmware update screen
   * @segue: triggered segue
   * @sender: trigger source
   */
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == self.segueOrder {
      
      let orderViewController = segue.destination as! OrderViewController
      orderViewController.orderDelegate = self
      orderViewController.snackViewModels = self.snackViewModels.filter { return $0.selected }
      
    }
    
  }
  
  /// Toggles including and excluding veggie snacks
  /// - Parameter Sender: Reference to switch
  @IBAction func toggleVeggie(Sender: UISwitch) {
    
    includeVeggies = self.veggieSwitch.isOn
    getFilteredSnacks()
    
  }
  
  /// Toggles including and exluding non veggie snacks
  /// - Parameter Sender: Reference to switch
  @IBAction func toggleNonVeggie(Sender: UISwitch) {
    
    includeNonVeggies = self.nonVeggieSwitch.isOn
    getFilteredSnacks()
    
  }
  
  // Retrieve list of snacks from services
  private func getSnacks() {
  
    _ = SnackService.instance.get()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { result in
        
        if result.success {
          
          do {
            
            if let returnedSnacks = try SnackService.instance.snacks.value() {
              
              self.allSnackViewModels = returnedSnacks.map{ return SnackViewModel($0) }
              self.getFilteredSnacks()
              
            }
            
          } catch {
            Logger.error("Unable to successfully retrieve snacks")
          }
          
        } else {
          
          Logger.error("Unable to successfully retrieve snacks")
          self.servicesUnavailable()
          
        }
        
      },
         onError: { error in
          
          Logger.error(error.localizedDescription)
          self.servicesUnavailable()
          
      },
         onCompleted: {
          Logger.info("Get snacks successful")
      })
      .disposed(by: self.disposeBag)
    
  }
  
  
  /// Returns snacks based upon user veggie and non veggie choices
  private func getFilteredSnacks() {
    
    if self.includeNonVeggies && self.includeVeggies {
      self.snackViewModels = self.allSnackViewModels
    } else if !self.includeNonVeggies && self.includeVeggies {
      self.snackViewModels = self.allSnackViewModels.filter { return $0.snackTypeId == Constants.veggieId }
    } else if self.includeNonVeggies && !self.includeVeggies {
      self.snackViewModels = self.allSnackViewModels.filter { return $0.snackTypeId == Constants.nonVeggieId }
    } else {
      self.snackViewModels = []
    }
    
    self.tableView.reloadData()
    
  }
  
  // Informs user that cannot reach web services
  private func servicesUnavailable() {
    
    let alert = UIAlertController(title: Constants.servicesUnavailableTitle,
                                  message: Constants.servicesUnavailableMessage, preferredStyle: .alert)
    
    let actionOk = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
      
      alert.dismiss(animated: true, completion: nil)
      
    }
    alert.addAction(actionOk)
    self.present(alert, animated: true, completion: nil)
    
  }
  
}

// Handles all table operations
extension MainViewController : UITableViewDelegate, UITableViewDataSource {
  
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
    
    let cell = tableView.dequeueReusableCell(withIdentifier: snackCellIdentifier, for: indexPath) as! SnackCell
    
    cell.snackViewModel = snackViewModels[indexPath.row]
    
    return cell
    
  }
  
  
  
  /// Triggers when the user touches an already selected row to unselect it
  /// - Parameters:
  ///   - tableView: Reference to table view
  ///   - indexPath: Current row position
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
    let selectedSnack = snackViewModels[indexPath.row]
    selectedSnack.selected = false
    
    if let cell = tableView.cellForRow(at: indexPath) {
      
      let label = cell.viewWithTag(100) as! UILabel
      label.text = selectedSnack.checkedText
      
    }
    
  }
  
  /// Triggers when the user touches an unselected row to select it
  /// - Parameters:
  ///   - tableView: Reference to table view
  ///   - indexPath: Current row position
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let selectedSnack = snackViewModels[indexPath.row]
    selectedSnack.selected = true
    
    if let cell = tableView.cellForRow(at: indexPath) {
      
      cell.selectionStyle = .none
      
      let label = cell.viewWithTag(100) as! UILabel
      label.text = selectedSnack.checkedText
      
    }
    
  }
}

/// Handles the results of adding an order
extension MainViewController: OrderDelegate {
  
  /// Triggers when order added
  /// - Parameter order: new order id
  func didAddOrder(id: Int) {
    
    allSnackViewModels.forEach { return $0.selected = false }
    
    veggieSwitch.isOn = true
    nonVeggieSwitch.isOn = true
    getFilteredSnacks()
    
    let alert = UIAlertController(title: Constants.orderAddedTitle,
                                  message: "\(Constants.orderAddedMessage) \(id)", preferredStyle: .alert)
    
    let actionOk = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
      
      alert.dismiss(animated: true, completion: nil)
      
    }
    alert.addAction(actionOk)
    self.present(alert, animated: true, completion: nil)
    
  }
  
  /// Indicates order add failed
  func didAddOrderFailure() {
    
    let alert = UIAlertController(title: Constants.orderAddedTitleFailure,
                                  message: "\(Constants.orderAddedFailureMessage)", preferredStyle: .alert)
    
    let actionOk = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
      
      alert.dismiss(animated: true, completion: nil)
      
    }
    alert.addAction(actionOk)
    self.present(alert, animated: true, completion: nil)
    
  }
  
}
