//
//  StringExtension.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 18/11/2021.
//

import Foundation

extension String {
  var localize: String {
    NSLocalizedString(self, comment: "")
  }
  
  func localizedWithArgs(_ args: [CVarArg]) -> String {
    return String(format: self.localize, arguments: args)
  }
}
