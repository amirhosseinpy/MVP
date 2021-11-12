//
//  RepositoryView.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 12/11/2021.
//

import UIKit
import SwiftUI
import Resolver

class RepositoryView: UIView {
  private var authorImageView: UIImageView!
  private var authorUserName: UILabel!
  private var repoName: UILabel!
  private var descriptionLabel: UILabel!
  private var language: UILabel!
  private var starCount: UILabel!
  
  private let dataSource: ProfilePresentationRepositoryModel
  
  static let calculatedHeight: CGFloat = 140
  
  // MARK: - init
  
  init(repo: ProfilePresentationRepositoryModel, width: CGFloat) {
    dataSource = repo
    
    let frameSize = CGSize(width: width, height: RepositoryView.calculatedHeight)
    
    super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frameSize))
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View
  private func setupView() {
    setupCurveFrame()
    setupImageView()
    setupAuthorName()
    setupRepoName()
    setupRepoDescription()
    setupStarsAndLanguage()
  }
  
  func setupCurveFrame() {
    layer.borderWidth = 1
    layer.borderColor = UIColor(named: Colors.borders.rawValue)?.cgColor
    layer.cornerRadius = 8
    
  }
  
  private func setupImageView() {
    authorImageView = UIImageView()
    addSubview(authorImageView)
    
    authorImageView.snp.makeConstraints { make in
      make.width.height.equalTo(32)
      make.top.leading.equalToSuperview().inset(16)
    }
    
    authorImageView.layer.cornerRadius = 16
    authorImageView.clipsToBounds = true
    authorImageView.setImage(urlString: dataSource.authorImageURL)
    
  }
  
  private func setupAuthorName() {
    authorUserName = UILabel()
    addSubview(authorUserName)
    
    authorUserName.snp.makeConstraints { make in
      make.leading.equalTo(authorImageView.snp.trailing).offset(8)
      make.trailing.equalToSuperview().inset(16)
      make.centerY.equalTo(authorImageView.snp.centerY)
    }
    
    authorUserName.font = .sans(16)
    authorUserName.text = dataSource.authorUserName
  }
  
  private func setupRepoName() {
    repoName = UILabel()
    addSubview(repoName)
    
    repoName.snp.makeConstraints { make in
      make.top.equalTo(authorImageView.snp.bottom).offset(4)
      make.leading.trailing.equalToSuperview().inset(16)
    }
    
    repoName.font = .sansMedium(16)
    repoName.text = dataSource.repositoryName
  }
  
  private func setupRepoDescription() {
    descriptionLabel = UILabel()
    addSubview(descriptionLabel)
    
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(repoName.snp.bottom).offset(4)
      make.leading.trailing.equalToSuperview().inset(16)
    }
    
    descriptionLabel.font = .sans(16)
    descriptionLabel.text = dataSource.description
  }
  
  private func setupStarsAndLanguage() {
    language = UILabel()
    starCount = UILabel()
    
    let starImageView = UIImageView(imageName: .star)
    starImageView.contentMode = .center
    
    let starStackView = UIStackView(arrangedSubviews: [starImageView, starCount])
    starStackView.spacing = 4
    
    let languageColorView = UIView()
    let languageStackView = UIStackView(arrangedSubviews: [languageColorView, language])
    languageStackView.spacing = 4
    
    let infoStackView = UIStackView(arrangedSubviews: [starStackView, languageStackView])
    infoStackView.spacing = 24
    
    addSubview(infoStackView)
    infoStackView.snp.makeConstraints { make in
      make.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(16)
      make.leading.bottom.equalToSuperview().inset(16)
      make.trailing.lessThanOrEqualToSuperview().inset(16)
    }
    
    languageColorView.snp.makeConstraints { make in
      make.height.width.equalTo(12)
    }
    
    starCount.font = .sans(16)
    language.font = .sans(16)
    
    starCount.text = "\(dataSource.starCount)"
    language.text = dataSource.language
    
    languageColorView.backgroundColor = dataSource.languageColor
    languageColorView.layer.cornerRadius = 6
    languageColorView.clipsToBounds = true
  }
}
