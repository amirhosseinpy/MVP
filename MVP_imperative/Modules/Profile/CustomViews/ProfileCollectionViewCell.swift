//
//  ProfileCollectionViewCell.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 16/11/2021.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
  
  
  override func prepareForReuse() {
    
    for view in subviews {
      view.removeFromSuperview()
    }
    
    super.prepareForReuse()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .clear
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView(model: ProfilePresentationRepositoryModel) {
    let repositoryView = RepositoryView(repo: model, width: self.frame.width)
    
    addSubview(repositoryView)
    
    repositoryView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
  }
}
