//
//  ProfileNetworkTests.swift
//  MVP_imperativeTests
//
//  Created by amirhosseinpy on 18/11/2021.
//

import XCTest
@testable import MVP_imperative


class ProfileNetworkTests: XCTestCase {
  var network: NetworkAgent!
  var expectation: XCTestExpectation!
  var router: ProfileAPIRouter!
  
  override func setUp() {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockURLProtocol.self]
    let urlSession = URLSession.init(configuration: configuration)
    
    network = NetworkAgent(session: urlSession)
    
    router = ProfileAPIRouter()
    
    expectation = expectation(description: "Profile Network Expectation")
  }
  
  func testProfileAPISuccessState() {
    // preparing response
    MockURLProtocol.requestHandler = { request in
      guard let url = ProfileAPIRouter.baseURL, request.url == url else {
        throw NetworkError.urlParsing
      }
      
      let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, self.stubJsonData() ?? Data())
    }
    
    // trigger request and check validity
    network.request(router, isRefresh: true) { response in
      switch response {
        case .success(let model):
          let testModel = ProfileTestModel()
          XCTAssertEqual(testModel.name, model.name ?? "", "Incorrect Name")
          XCTAssertEqual(testModel.avatar, model.avatarUrl ?? "", "Incorrect Avatar URL")
          
          XCTAssertEqual(testModel.email, model.email ?? "", "Incorrect Email")
          XCTAssertEqual(testModel.username, model.login ?? "", "Incorrect Username")
          XCTAssertEqual(testModel.followers, model.followers?.totalCount ?? -1, "Incorrect Followers")
          XCTAssertEqual(testModel.following, model.following?.totalCount ?? -1, "Incorrect Following")
          
          let pinnedItems = model.pinnedItems?.edges?[0].node
          let pinnedLanguages = pinnedItems?.languages.edges?[0].node
          XCTAssertEqual(testModel.repoName, pinnedItems?.name ?? "", "Incorrect Pinned Repository name")
          XCTAssertEqual(testModel.description, pinnedItems?.description ?? "", "Incorrect Pinned Repository Description")
          XCTAssertEqual(testModel.starsCount, pinnedItems?.stargazerCount ?? -1, "Incorrect Pinned Repository Star Count")
          XCTAssertEqual(testModel.languageName, pinnedLanguages?.name ?? "", "Incorrect Pinned Repository Language")
          XCTAssertEqual(testModel.languageColor, pinnedLanguages?.color ?? "", "Incorrect Pinned Repository Language Color")
          
          let topItems = model.pinnedItems?.edges?[0].node
          let topLanguages = pinnedItems?.languages.edges?[0].node
          XCTAssertEqual(testModel.repoName, topItems?.name ?? "", "Incorrect Top Repository name")
          XCTAssertEqual(testModel.description, topItems?.description ?? "", "Incorrect Top Repository Description")
          XCTAssertEqual(testModel.starsCount, topItems?.stargazerCount ?? -1, "Incorrect Top Repository Star Count")
          XCTAssertEqual(testModel.languageName, topLanguages?.name ?? "", "Incorrect Top Repository Language")
          XCTAssertEqual(testModel.languageColor, topLanguages?.color ?? "", "Incorrect Top Repository Language Color")
          
          let starredItems = model.pinnedItems?.edges?[0].node
          let starredLanguages = pinnedItems?.languages.edges?[0].node
          XCTAssertEqual(testModel.repoName, starredItems?.name ?? "", "Incorrect Starred Repository name")
          XCTAssertEqual(testModel.description, starredItems?.description ?? "", "Incorrect Starred Repository Description")
          XCTAssertEqual(testModel.starsCount, starredItems?.stargazerCount ?? -1, "Incorrect Starred Repository Star Count")
          XCTAssertEqual(testModel.languageName, starredLanguages?.name ?? "", "Incorrect Starred Repository Language")
          XCTAssertEqual(testModel.languageColor, starredLanguages?.color ?? "", "Incorrect Starred Repository Language Color")
          
        case .failure(let error):
          XCTFail("Error was not expected: \(error)")
      }
      self.expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 1.0)
  }
  
  func testProfileAPIParsingErrorState() {
    MockURLProtocol.requestHandler = { request in
      guard let url = ProfileAPIRouter.baseURL, request.url == url else {
        throw NetworkError.urlParsing
      }
      
      let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, Data())
    }
    
    network.request(router, isRefresh: true) { response in
      switch response {
        case .success(_):
          XCTFail("Success Not Expected!")
        case .failure(let error):
          guard let error = error as? NetworkError else {
            print(error)
            XCTFail("Incorrect Error Received.")
            
            self.expectation.fulfill()
            
            return
          }
          
          XCTAssertEqual(error, NetworkError.parsing, "Parsing error was expected.")
          
      }
      
      self.expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 1.0)
  }
  
  
  private func stubJsonData(testModel: ProfileTestModel = ProfileTestModel()) -> Data? {
    let rawJson = """
                  {
                  "data": {
                  "user": {
                  \(stubHeader(testModel: testModel)),
                  "pinnedItems": \(stubRepositories(testModel: testModel)),
                  "starredRepositories": \(stubRepositories(testModel: testModel)),
                  "topRepositories": \(stubRepositories(testModel: testModel))
                  }
                  }
                  }
                  """
    return rawJson.data(using: .utf8)
  }
  
  private func stubHeader(testModel: ProfileTestModel) -> String {
    let header = """
                 "name": "\(testModel.name)",
                  "avatarUrl": "\(testModel.avatar)",
                  "email": "\(testModel.email)",
                  "login": "\(testModel.username)",
                  "followers": {
                  "totalCount": \(testModel.followers)
                  },
                  "following": {
                  "totalCount": \(testModel.following)
                  }
                 """
    
    return header
  }
  
  private func stubRepositories(testModel: ProfileTestModel) -> String {
    let repository = """
                       {
                       "edges": [
                       {
                        "node": {
                            "name": "\(testModel.repoName)",
                            "description": "\(testModel.description)",
                            "stargazerCount": \(testModel.starsCount),
                            "languages": {
                                "edges": [
                                    {
                                        "node": {
                                            "name": "\(testModel.languageName)",
                                            "color": "\(testModel.languageColor)"
                                        }
                                    }
                                ]
                            }
                        }
                       }
                       ]
                       }
                       """
    return repository
  }
}

struct ProfileTestModel {
  let name = "Amirhossein Validabadi"
  let avatar = "https://avatars.githubusercontent.com"
  let email = "amirhossein.validabadi@gmail.com"
  let username = "amirhosseinpy"
  let followers = 12
  let following = 124
  let repoName = "MVP"
  let description = "This is a MVP base app"
  let starsCount = 312
  let languageName = "Swift"
  let languageColor = "#FFF000"
}
