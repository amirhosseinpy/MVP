//
//  ProfileModel.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 14/11/2021.
//

import Foundation

struct ProfileServerModel: Codable {
  let name: String?
  let email: String?
  let avatarUrl: String?
  let login: String?
  let followers: ProfileServerFollowCountModel?
  let following: ProfileServerFollowCountModel?
  let pinnedItems: ProfileServerEdgesModel<ProfileServerRepositoryModel>?
  let starredRepositories: ProfileServerEdgesModel<ProfileServerRepositoryModel>?
  let topRepositories: ProfileServerEdgesModel<ProfileServerRepositoryModel>?
}

struct ProfileServerFollowCountModel: Codable {
  let totalCount: Int?
}

struct ProfileServerRepositoryModel: Codable {
  let name: String?
  let description: String?
  let stargazerCount: Int?
  let languages: ProfileServerEdgesModel<ProfileServerLanguangeModel>
}

struct ProfileServerLanguangeModel: Codable {
  let name: String?
  let color: String?
}


struct ProfileServerEdgesModel<D: Codable>: Codable {
  let edges: [ProfileServerNodeModel<D>]?
}

struct ProfileServerNodeModel<D: Codable>: Codable {
  let node: D?
}
