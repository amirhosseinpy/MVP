//
//  ProfileHeaderView.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 12/11/2021.
//

import UIKit

class ProfileHeaderView: UIView {
  private let profileImageView = UIImageView()
  private let nameLabel = UILabel()
  private let usernameLabel = UILabel()
  private let emailLabel = UILabel()
  private let followingLabel = UILabel()
  private let followersLabel = UILabel()
  
  private let dataSource: ProfilePresentationHeaderModel
  
  // MARK: - init
  init(header: ProfilePresentationHeaderModel, width: CGFloat) {
    dataSource = header
    
    let calculatedHeight: CGFloat = 176
    let frameSize = CGSize(width: width, height: calculatedHeight)
    
    super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frameSize))
    
    setupView()
    setupStyle()
    setupData()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View
  private func setupView() {
    setupImageView()
    setupNameAndUsername()
    setupEmail()
    setupFollowingAndFollowers()
  }
  
  private func setupImageView() {
    
    addSubview(profileImageView)
    
    profileImageView.snp.makeConstraints { make in
      make.width.height.equalTo(88)
      make.top.equalTo(self)
      make.leading.equalTo(self).inset(16)
    }
  }
  
  private func setupNameAndUsername() {
    let nameStackView = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
    nameStackView.axis = .vertical
    addSubview(nameStackView)
    
    nameStackView.snp.makeConstraints { make in
      make.leading.equalTo(profileImageView.snp.trailing).offset(8)
      make.trailing.equalTo(self).inset(16)
      make.centerY.equalTo(profileImageView.snp.centerY)
    }
  }
  
  private func setupEmail() {
    addSubview(emailLabel)
    
    emailLabel.snp.makeConstraints { make in
      make.leading.trailing.equalTo(self).inset(16)
      make.top.equalTo(profileImageView.snp.bottom).offset(24)
    }
  }
  
  private func setupFollowingAndFollowers() {
    let followStackView = UIStackView(arrangedSubviews: [followersLabel, followingLabel])
    followStackView.spacing = 24
    followStackView.distribution = .fill
    addSubview(followStackView)
    
    followStackView.snp.makeConstraints { make in
      make.top.equalTo(emailLabel.snp.bottom).offset(16)
      make.leading.equalToSuperview().inset(16)
      make.trailing.lessThanOrEqualToSuperview().inset(16)
      make.bottom.equalTo(self)
    }
  }
  
  private func setupStyle() {
    profileImageView.clipsToBounds = true
    profileImageView.layer.cornerRadius = 44
    
    nameLabel.font = UIFont.sansBold(32)
    usernameLabel.font = UIFont.sans(16)
    emailLabel.font = .sansMedium(16)
    
    followingLabel.font = .sans(16)
    followersLabel.font = .sans(16)
  }
  
  private func setupData() {
    profileImageView.setImage(urlString: dataSource.imageURL)
    nameLabel.text = dataSource.fullName
    usernameLabel.text = dataSource.username
    emailLabel.text = dataSource.email
    followersLabel.text = ProfileText.followers.rawValue.localizedWithArgs(["\(dataSource.followers)"])
    followingLabel.text = ProfileText.following.rawValue.localizedWithArgs(["\(dataSource.following)"])
  }
}
