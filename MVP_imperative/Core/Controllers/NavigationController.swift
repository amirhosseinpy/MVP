//
//  NavigationController.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 13/11/2021.
//

import UIKit

class NavigationController: UINavigationController {
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupStyle()
  }
  
  func setupStyle() {
    navigationBar.tintColor = UIColor(named: Colors.primary.rawValue)
    navigationBar.backgroundColor = UIColor(named: Colors.primary.rawValue)
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = false
    navigationBar.barTintColor = UIColor(named: Colors.primary.rawValue)
    view.backgroundColor = UIColor(named: Colors.primary.rawValue)
    
    let barButtonAttributes = [NSAttributedString.Key.font: UIFont.sansMedium(20)]
    UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: .normal)
  }
}
