//
//  ProfilePresenterTests.swift
//  MVP_imperativeTests
//
//  Created by amirhosseinpy on 18/11/2021.
//

import Foundation
import XCTest
@testable import MVP_imperative

class ProfilePresenterTests: XCTestCase {
  var presenter: ProfilePresenter!
  var expectation: XCTestExpectation!
  
  override func setUp() {
    presenter = ProfilePresenter()
    
  }
  
  func testSummerizeStarCountLessThan1000() {
    let starCount = 321
    
    let summerized = presenter.summerizeStarCount(starCount: starCount)
    
    XCTAssertEqual(summerized, "\(starCount)")
    
  }
  
  func testSummerizeStarCountMoreThan1000() {
    let starCount = 3246
    
    let summerized = presenter.summerizeStarCount(starCount: starCount)
    
    XCTAssertEqual(summerized, "3.2K")
    
  }
  
  func testSuccessConvertingServerHeaderModelToPresentationModel() {
    let convertedPresentationModel = presenter.convertHeader(serverModel: stubServerHeaderModel())
    let stubModel = stubPresentationHeaderModel()
    
    XCTAssertEqual(convertedPresentationModel.fullName, stubModel.fullName, "Incorrect Name")
    XCTAssertEqual(convertedPresentationModel.imageURL, stubModel.imageURL, "Incorrect Image URL")
    XCTAssertEqual(convertedPresentationModel.username, stubModel.username, "Incorrect Username")
    XCTAssertEqual(convertedPresentationModel.email, stubModel.email, "Incorrect Email")
    XCTAssertEqual(convertedPresentationModel.following, stubModel.following, "Incorrect Following")
    XCTAssertEqual(convertedPresentationModel.followers, stubModel.followers, "Incorrect Followers")
    
  }
  
  func testSuccessConvertingServerRepositoryToPresentationModel() {
    let convertedPresentationModel = presenter.convertRepositories(serverRepos: stubServerRepositoryModel(),
                                                                   avatarURLString: "http://test.avatar.com",
                                                                   userName: "amirhosseinpy")[0]
    let stubModel = stubPresentationRepositoryModel()
    
    XCTAssertEqual(convertedPresentationModel.authorImageURL, stubModel.authorImageURL, "Incorrect Author URL")
    XCTAssertEqual(convertedPresentationModel.authorUserName, stubModel.authorUserName, "Incorrect Author Username")
    
    XCTAssertEqual(convertedPresentationModel.repositoryName, stubModel.repositoryName, "Incorrect Repository Name")
    XCTAssertEqual(convertedPresentationModel.description, stubModel.description, "Incorrect Description")
    XCTAssertEqual(convertedPresentationModel.language, stubModel.language, "Incorrect Language")
    XCTAssertEqual(convertedPresentationModel.languageColor, stubModel.languageColor, "Incorrect Language Color")
    XCTAssertEqual(convertedPresentationModel.starCount, stubModel.starCount, "Incorrect Star count")
    
  }
  
  
  private func stubServerRepositoryModel() -> ProfileServerEdgesModel<ProfileServerRepositoryModel> {
    
    let language = ProfileServerLanguangeModel(name: "Swift", color: "#FF12CD")
    let langNode = ProfileServerNodeModel<ProfileServerLanguangeModel>(node: language)
    let edge = ProfileServerEdgesModel<ProfileServerLanguangeModel>(edges: [langNode])
    let repo = ProfileServerRepositoryModel(name: "Test repo",
                                        description: "This is a test repo",
                                        stargazerCount: nil,
                                        languages: edge)
    let node = ProfileServerNodeModel<ProfileServerRepositoryModel>(node: repo)
    return ProfileServerEdgesModel<ProfileServerRepositoryModel>(edges: [node])
  }
  
  private func stubServerHeaderModel() -> ProfileServerModel {
    ProfileServerModel(name: "Amirhossein",
                       email: "amirhossein.validabadi@gmail.com",
                       avatarUrl: "http://test.avatar.com",
                       login: "amirhosseinpy",
                       followers: ProfileServerFollowCountModel(totalCount: 12),
                       following: ProfileServerFollowCountModel(totalCount: 43),
                       pinnedItems: nil,
                       starredRepositories: nil,
                       topRepositories: nil)
  }
  
  private func stubPresentationHeaderModel() -> ProfilePresentationHeaderModel {
    return ProfilePresentationHeaderModel(imageURL: "http://test.avatar.com",
                                          fullName: "Amirhossein",
                                          username: "amirhosseinpy",
                                          email: "amirhossein.validabadi@gmail.com",
                                          followers: "12",
                                          following: "43")
  }
  
  private func stubPresentationRepositoryModel() -> ProfilePresentationRepositoryModel {
    return ProfilePresentationRepositoryModel(authorImageURL: "http://test.avatar.com",
                                              authorUserName: "amirhosseinpy",
                                              repositoryName: "Test repo",
                                              description: "This is a test repo",
                                              language: "Swift",
                                              languageColor: UIColor(netHexString: "#FF12CD"),
                                              starCount: "0")
  }
}
