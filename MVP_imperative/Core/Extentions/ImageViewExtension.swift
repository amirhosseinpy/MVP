//
//  ImageViewExtension.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 12/11/2021.
//

import UIKit
import Kingfisher

extension UIImageView {
  func setImage(urlString: String?, completionHandler: ((ImageDownloadResult) -> Void)? = nil ) {
    if let urlString = urlString, let url = URL(string: urlString) {
      self.kf.setImage(with: url, completionHandler: { (result) in
        switch result {
          case .success:
            completionHandler?(.success)
          case .failure:
            completionHandler?(.fail)
        }
      })
    } else {
      completionHandler?(.fail)
    }
  }
  
  convenience init(imageName: ImagesName) {
    self.init(image: UIImage(named: imageName.rawValue))
  }
  
  func setImage(named: ImagesName) {
    self.image = UIImage(named: named.rawValue)
  }
}

enum ImageDownloadResult {
  case success
  case fail
}
