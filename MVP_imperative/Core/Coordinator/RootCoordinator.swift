//
//  RootCoordinator.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 13/11/2021.
//

import UIKit

class RootCoordinator: CoordinatorDelegate {
  
  var window: UIWindow?
  
  var navigationController: UINavigationController
  
  init(window: UIWindow) {
    
    self.navigationController = NavigationController()
    self.window = window
    
  }
  
  func start() {
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    
    let coordinator = ProfileCoordinator(navigationController)
    coordinator.start()
  }
}
