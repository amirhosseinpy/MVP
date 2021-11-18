//
//  ViewController.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 12/11/2021.
//

import UIKit
import SnapKit
import Resolver

class ProfileViewController: BaseViewController<ProfilePresenter, ProfileCoordinator> {
  private var scrollView: UIScrollView!
  private var rootStackView: UIStackView!
  private var topCollectionView: UICollectionView!
  private var starredCollectionView: UICollectionView!
  private var refreshControl: UIRefreshControl!
  private var activityIndicator: UIActivityIndicatorView!
  
  private var profileModel: ProfilePresentationModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = ProfileText.title.rawValue.localize
    
    setupScrollView()
    
    setupRootStackView()
    
    setupActivityIndicator()
    
    activityIndicator.startAnimating()
    
    presenter.setDelegate(delegate: self)
    
    
    presenter.getProfile(isRefresh: false)
  }
  
  private func setupScrollView() {
    scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    
    view.addSubview(scrollView)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
    
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    scrollView.addSubview(refreshControl)
    
  }
  
  
  @objc private func refresh(_ sender: AnyObject) {
    presenter.getProfile(isRefresh: true)
  }
  
  
  func setupRootStackView() {
    rootStackView = UIStackView()
    rootStackView.spacing = 24
    rootStackView.alignment = .center
    rootStackView.axis = .vertical
    scrollView.addSubview(rootStackView)
    
    
    rootStackView.snp.makeConstraints { (make) -> Void in
      make.leading.trailing.equalTo(view)
      make.top.bottom.equalToSuperview().inset(24)
      make.width.equalToSuperview()
    }
  }
  
  func setupActivityIndicator() {
    activityIndicator = UIActivityIndicatorView()
    view.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.height.width.equalTo(100)
    }
  }
  
  private func setupViews() {
    self.setupHeader()
    self.setupPinnedRepositories()
    self.setupTopRepositories()
    self.setupStarredRepositories()
  }
  
  private func setupHeader() {
    let headerView = ProfileHeaderView(header: profileModel.header, width: rootStackView.frame.width)
    rootStackView.addArrangedSubview(headerView)
    
    headerView.snp.makeConstraints { make in
      make.leading.trailing.equalTo(rootStackView)
    }
  }
  
  private func setupPinnedRepositories() {
    let pinnedStackView = UIStackView()
    pinnedStackView.axis = .vertical
    pinnedStackView.spacing = 16
    
    let pinnedHeader = setupSectionHeader(topic: ProfileText.pinned.rawValue.localize)
    pinnedStackView.addArrangedSubview(pinnedHeader)
    
    for item in profileModel.pinnedRepositories {
      let repositoryView = RepositoryView(repo: item, width: rootStackView.frame.width)
      pinnedStackView.addArrangedSubview(repositoryView)
    }
    
    rootStackView.addArrangedSubview(pinnedStackView)
    
    pinnedStackView.snp.makeConstraints { make in
      make.leading.trailing.equalTo(rootStackView).inset(16)
    }
  }
  
  private func setupTopRepositories() {
    let topStackView = UIStackView()
    topStackView.axis = .vertical
    topStackView.alignment = .center
    topStackView.spacing = 16
    
    let topHeader = setupSectionHeader(topic: ProfileText.top.rawValue.localize)
    
    topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCollection())
    topCollectionView.showsHorizontalScrollIndicator = false
    topCollectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileText.topCell.rawValue)
    topCollectionView.backgroundColor = .clear
    
    topStackView.addArrangedSubview(topHeader)
    
    topStackView.addArrangedSubview(topCollectionView)
    
    rootStackView.addArrangedSubview(topStackView)
    
    topHeader.snp.makeConstraints { make in
      make.leading.trailing.equalTo(rootStackView).inset(16)
    }
    
    topCollectionView.snp.makeConstraints { make in
      make.height.equalTo(RepositoryView.calculatedHeight)
      make.leading.trailing.equalTo(rootStackView)
    }
    
    topCollectionView.dataSource = self
  }
  
  private func setupStarredRepositories() {
    let starredStackView = UIStackView()
    starredStackView.axis = .vertical
    starredStackView.alignment = .center
    starredStackView.spacing = 16
    
    let starredHeader = setupSectionHeader(topic: ProfileText.starred.rawValue.localize)
    
    starredCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCollection())
    starredCollectionView.showsHorizontalScrollIndicator = false
    starredCollectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileText.starredCell.rawValue)
    starredCollectionView.backgroundColor = .clear
    
    starredStackView.addArrangedSubview(starredHeader)
    
    starredStackView.addArrangedSubview(starredCollectionView)
    
    rootStackView.addArrangedSubview(starredStackView)
    
    starredHeader.snp.makeConstraints { make in
      make.leading.trailing.equalTo(rootStackView).inset(16)
    }
    
    starredCollectionView.snp.makeConstraints { make in
      make.height.equalTo(RepositoryView.calculatedHeight)
      make.leading.trailing.equalTo(rootStackView)
    }
    
    starredCollectionView.dataSource = self
  }
  
  
  private func setupCollection() -> UICollectionViewFlowLayout {
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    layout.itemSize = CGSize(width: view.frame.width / 2, height: RepositoryView.calculatedHeight)
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 16
    layout.minimumLineSpacing = 16
    return layout
  }
  
  private func setupSectionHeader(topic: String) -> UIStackView {
    let sectionTopic = setupTopicLabel(text: topic)
    let viewAll = setupViewAllLabel()
    let headerStackView = UIStackView(arrangedSubviews: [sectionTopic, viewAll])
    headerStackView.distribution = .equalSpacing
    
    return headerStackView
  }
  
  private func setupTopicLabel(text: String) -> UILabel {
    let topicLabel = UILabel()
    topicLabel.font = .sansBold(24)
    topicLabel.text = text
    topicLabel.textColor = UIColor(named: Colors.secondary.rawValue)
    
    return topicLabel
  }
  
  private func setupViewAllLabel() -> UILabel {
    let viewAll = UnderlinedLabel()
    viewAll.font = .sansBold(16)
    viewAll.text = ProfileText.viewAll.rawValue.localize
    viewAll.textColor = UIColor(named: Colors.secondary.rawValue)
    
    return viewAll
  }
  
  private func resetViews() {
    for view in rootStackView.subviews {
      view.removeFromSuperview()
    }
  }
  
  
}

extension ProfileViewController: ProfilePresenterDelegate {
  func presentProfile(profileModel: ProfilePresentationModel) {
    self.profileModel = profileModel
    
    DispatchQueue.main.async {
      self.activityIndicator.stopAnimating()
      
      self.resetViews()
      
      self.refreshControl.endRefreshing()
      
      self.setupViews()
    }
  }
  
  func showFailureAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: ProfileText.dismiss.rawValue, style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}

extension ProfileViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if collectionView == topCollectionView {
      return profileModel.topRepositories.count
      
    } else {
      return profileModel.starredRepositories.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView == topCollectionView {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileText.topCell.rawValue, for: indexPath)
              as? ProfileCollectionViewCell else { return UICollectionViewCell() }
      
      cell.setupView(model: profileModel.topRepositories[indexPath.item])
      return cell
      
    } else {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileText.starredCell.rawValue, for: indexPath)
              as? ProfileCollectionViewCell else { return UICollectionViewCell() }
      
      cell.setupView(model: profileModel.starredRepositories[indexPath.item])
      return cell
    }
  }
}
