//
//  CacheTests.swift
//  MVP_imperativeTests
//
//  Created by amirhosseinpy on 18/11/2021.
//

import XCTest
@testable import MVP_imperative

class CacheTests: XCTestCase {
  var cacheAgent: CacheAgent!
  var expectation: XCTestExpectation!
  
  override func setUp() {
    cacheAgent = CacheAgent(duration: 5)
    expectation = expectation(description: "Cache Agent Expectation")
  }
  
  func testExpirationOfCache() {
    let value =  "Value To Be Cached"
    let model = CacheTestModel(value: value)
    
    let keyData = value.data(using: .utf8) ?? Data()
    
    cacheAgent.store(data: model, forKey: keyData)
    
    let result = XCTWaiter.wait(for: [expectation], timeout: 6.0)
    
    if result == XCTWaiter.Result.timedOut {
      let valueModel: CacheTestModel? = cacheAgent.fetch(forKey: keyData)
      XCTAssertEqual(valueModel, nil, "Having Value Not Expected")
      expectation.fulfill()
      
    } else {
      XCTFail("Delay Interrupted")
    }
  }
  
  func testAccessibilityOfCache() {
    let value =  "Value To Be Cached"
    let model = CacheTestModel(value: value)
    
    let keyData = value.data(using: .utf8) ?? Data()
    
    cacheAgent.store(data: model, forKey: keyData)
    
    let valueModel: CacheTestModel? = cacheAgent.fetch(forKey: keyData) ?? CacheTestModel(value: "")
    
    XCTAssertEqual(valueModel, model, "Incorrect Cache Value")
    expectation.fulfill()
    
    wait(for: [expectation], timeout: 1.0)
  }
}

struct CacheTestModel: Codable, Equatable {
  let value: String
}
