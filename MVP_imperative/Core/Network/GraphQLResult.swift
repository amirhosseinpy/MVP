//
//  GraphQLResult.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 14/11/2021.
//

import Foundation

struct GraphQLResult<D: Decodable>: Decodable {
  let value: D?
  let errorMessages: [String]
  
  enum CodingKeys: String, CodingKey {
    case data
    case errors
  }
  
  struct Error: Decodable {
    let message: String
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let dataDict = try container.decodeIfPresent([String: D].self, forKey: .data)
    self.value = dataDict?.values.first
    
    var errorMessages: [String] = []
    
    let errors = try container.decodeIfPresent([Error].self, forKey: .errors)
    if let errors = errors {
      for error in errors {
        errorMessages.append(error.message)
      }
    }
    
    self.errorMessages = errorMessages
  }
}

struct GraphQLRequest<C: Codable>: Codable {

  let variables: C?
  let query: String
  
}

struct BaseCodableModel: Codable {}
