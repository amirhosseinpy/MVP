//
//  APIRouter.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 14/11/2021.
//

import UIKit

public enum HTTPMethod: String, Encodable {
  case post = "POST"
}

protocol APIRouter {
  
  associatedtype ResponseType: Codable
  static var method: HTTPMethod { get }
  static var baseURL: URL? { get }
  static var canRetry: Bool { get }
  
  var request: GraphQLRequest<BaseCodableModel> { get }
}

extension APIRouter {
  public static var method: HTTPMethod {
    return .post
  }
  
  public static var canRetry: Bool {
    return true
  }
  
  public static var baseURL: URL? {
    return URL(string: "https://api.github.com/graphql")
  }
}
