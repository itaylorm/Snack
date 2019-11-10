# Snack
Proof of Concept Swift based project

# Setup

After you clone the project, run Pod install to copy down the different dependencies

# Dependencies

RxSwift, RxCocoa, RxAlamofire
  Provides support for observables and easier asynchronous call support
  https://github.com/ReactiveX/RxSwift

Alamofire
  HTTP networking support
  https://cocoapods.org/pods/Alamofire

SwiftyJSON
  Ehanced JSON handling 
  https://github.com/SwiftyJSON/SwiftyJSON
  
# Project Structure
This is a XCode 11 project which uses a single story board 

## There are two screens
  ### Main - Displays a list of snacks and allows the user to pick the ones they want to order
  ### Order - Allows user to review an order and submit
  
 Mock System
  There are mock files behind the service classes in the project that provide simulated communication results
  
  SnackMock - Provides list of snacks
  OrderMock - Provides simulated response to an order add
              Also returns an incremented order number
Common
  Constants - Common text entries used in the project
  Setting - Means to control which Urls and settings are to be used based upon the Application Mode
            Initially set in the MainViewController didLoad event
  ApplicationMode - Enum that specifies possible groupings of settings including Development, Test, Production, and Mock
  Logger - Custom solution that allows log entries to be scoped at different levels including Verbose, Debug, Info, Error
  
Extensions
  Formatter - Provides a means to handle date times where seconds are missing which happens with Azure servers
  
Models
  Snack - Represents a food item
  SnackType - kind of food (Currently Veggie and Non Veggie) by which snacks are categorized
  User - Added for future use to allow customers and admin users to have secured access
  UserType - Allows users to be classified with levels of access (Example: Cook who could see list of orders to fill)
  Order - Food order
  OrderLine - Individual food choice in an order
  Result - The success or failure of a web service call returned along with associated data
  
Service
  Service - Low level calls for calling web services including Get, Post, and Put
  ServiceProtocol - Allows a service call to be mocked and inserted into a service like OrderService for simulating calls
  SnackService - Handles calls to snack (DI solution which can have Mock or Live setup in init)
  SnackMock - Implements ServiceProtocol that represent return value from get snacks
  OrderService - Handles calls for order (DI Solution which can have Mock or Live setup in init)
  OrderMock - Implements ServiceProtocol that represent return value from add order
  
View Controllers
  HomeController for Snacks list and choices
  OrderController for Snacks selected list
  
View Models
  SnackViewModel to display snack in tables in Order and Main controllers
  
Views
  Contains the UITableViewCell files for displaying custom rows in the tables for 
  
