//
//  ColorExtension.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 12/11/2021.
//

import UIKit

extension UIColor {
  convenience init(netHex: UInt) {
    let red = (netHex >> 16) & 0xff
    let green = (netHex >> 8) & 0xff
    let blue = netHex & 0xff
    
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    let p3red = CGFloat(red) / 255.0
    let p3green = CGFloat(green) / 255.0
    let p3blue = CGFloat(blue) / 255.0
    self.init(displayP3Red: p3red, green: p3green, blue: p3blue, alpha: 1.0)
  }
  
  convenience init(netHexString: String) {
    let rawHex = netHexString.replacingOccurrences(of: "#", with: "")
    if let hex = UInt(rawHex, radix: 16) {
      self.init(netHex: hex)
    } else {
      self.init(red: 0, green: 0, blue: 0, alpha: 0.0)
    }
  }
  
}
