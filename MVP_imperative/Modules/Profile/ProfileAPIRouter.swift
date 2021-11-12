//
//  ProfileAPIRouter.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 14/11/2021.
//

import Foundation

struct ProfileAPIRouter: APIRouter {

  var request: GraphQLRequest<BaseCodableModel>
  
  typealias ResponseType = ProfileServerModel
  
  init( ) {
    
    
    let query = """
query {
user(login: "twostraws") {
  name
  avatarUrl
  email
  login
  followers {
    totalCount
  }
  following {
    totalCount
  }
  pinnedItems(first: 3, types: REPOSITORY) {
    edges {
      node {
        ... on Repository {
          name
          description
          stargazerCount
          languages(first: 1) {
            edges {
              node {
                name
                color
              }
            }
          }
        }
      }
    }
  }
starredRepositories: repositories(first: 10, orderBy: {field: STARGAZERS, direction: DESC}) {
  edges {
    node {
      name
      description
      stargazerCount
      createdAt
      languages(first: 1) {
        edges {
          node {
            name
            color
          }
        }
      }
    }
  }
}
topRepositories: repositories(first: 10, orderBy: {field: CREATED_AT, direction: DESC}) {
  edges {
    node {
      name
      description
      stargazerCount
      createdAt
      languages(first: 1) {
        edges {
          node {
            name
            color
          }
        }
      }
    }
  }
}
}
}
"""
    
    request = GraphQLRequest(variables: nil, query: query)
  }
}
