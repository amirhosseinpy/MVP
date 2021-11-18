//
//  Fonts.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 12/11/2021.
//

import UIKit

extension UIFont {
  static func sansBold(_ size: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size)
  }
  
  static func sansMedium(_ size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
  }
  
  static func sans(_ size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
  }
}
