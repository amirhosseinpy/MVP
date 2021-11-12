//
//  Cache.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 16/11/2021.
//

import Foundation
import Resolver

struct CacheAgent {

  @Injected private var cacher: UserDefaultAgent
  private let duration: TimeInterval

  init(duration: TimeInterval) {
    self.duration = duration
  }

  func store<C: Codable>(data: C, forKey key: Data) { // data is httpbody
    
    let expireDate = Date().addingTimeInterval(duration)
    let expirableCache = ExpirableCache(value: data, expireDate: expireDate)

    if let key = String(data: key, encoding: .utf8) {
      cacher.save(expirableCache, forKey: key)
    }
  }

  func fetch<C: Codable>(forKey key: Data) -> C? {
    guard let key = String(data: key, encoding: .utf8) else {
      return nil
    }

    if let expirableCache: ExpirableCache<C> = cacher.get(forKey: key) {
        if expirableCache.expireDate > Date() {
          return expirableCache.value
          
        } else {
          cacher.remove(forKey: key)
        }
    }

    return nil
  }
}


struct ExpirableCache<C: Codable>: Codable {
  let value: C
  let expireDate: Date

  init(value: C, expireDate: Date) {
    self.expireDate = expireDate
    self.value = value
  }
}
