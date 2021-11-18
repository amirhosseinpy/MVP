//
//  ProfileCoordinator.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 13/11/2021.
//
import UIKit


class ProfileCoordinator: CoordinatorDelegate {
  var navigationController: UINavigationController
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let viewController = ProfileViewController()
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }
}
