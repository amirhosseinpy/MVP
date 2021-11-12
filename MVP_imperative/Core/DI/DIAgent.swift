//
//  DIAgent.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 15/11/2021.
//

import Foundation
import Resolver

struct DIAgent {
  
  init() {
    _ = DefaultDIAgent()
    _ = PresenterDIAgent()
  }
}

struct DefaultDIAgent {
  init() {
    Resolver.register { UserDefaultAgent() }
    Resolver.register { NetworkAgent(cacher: CacheAgent(duration: 24*60*60)) } // 24 hours
  }
}

struct PresenterDIAgent {
  
  init() {
    Resolver.register { ProfilePresenter() }
  }
}
