//
//  ViewController.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 15/11/2021.
//

import UIKit
import Resolver

protocol ViewControllerDelegate: AnyObject {
  associatedtype Presenter: Presentable
  associatedtype Coordinator: CoordinatorDelegate
}

class BaseViewController<Presenter: Presentable, Coordinator: CoordinatorDelegate>: UIViewController {
  
  var coordinator: Coordinator?
  @Injected var presenter: Presenter
}

protocol Presentable {}

protocol PeresenterDelegate: AnyObject {}
