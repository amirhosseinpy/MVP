//
//  UserDefaultAgent.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 17/11/2021.
//

import Foundation

class UserDefaultAgent {
  
  func save<T: Encodable>(_ value: T?, forKey key: String) {
    if T.self == String.self {
      UserDefaults.standard.set(value as? String, forKey: key)
      
    } else if  T.self == Int.self {
      UserDefaults.standard.set(value as? Int, forKey: key)
      
    } else if T.self == Double.self {
      UserDefaults.standard.set(value as? Double, forKey: key)
      
    } else {
      let data = try? JSONEncoder().encode(value)
      assert(data != nil, "UserDefaultAgent Error the type could not convert to json.")
      UserDefaults.standard.set(data, forKey: key)
    }
    
    UserDefaults.standard.synchronize()
  }
  
  func get<T: Decodable>(forKey key: String) -> T? {
    let userDefault =  UserDefaults.standard
    
    if T.self == String.self {
      return userDefault.string(forKey: key) as? T
      
    } else if  T.self == Int.self {
      return userDefault.integer(forKey: key) as? T
      
    } else if T.self == Double.self {
      return userDefault.double(forKey: key) as? T
      
    } else {
      if let encodedData = userDefault.data(forKey: key) {
        return try? JSONDecoder().decode(T.self, from: encodedData)
      }
    }
    
    return nil
  }
  
  func remove(forKey key: String) {
    let userDefault =  UserDefaults.standard
    userDefault.removeObject(forKey: key)
  }
  
  func resetDefaults() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
      defaults.removeObject(forKey: key)
    }
  }
}
