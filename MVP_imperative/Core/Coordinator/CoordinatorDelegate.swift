//
//  CoordinatorDelegate.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 13/11/2021.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
  var navigationController: UINavigationController { get set }
  
  func start()
}

protocol Coordinatable {
  var coordinator: CoordinatorDelegate? { get set }
}
