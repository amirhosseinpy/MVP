//
//  ProfilePresentationModel.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 15/11/2021.
//

import UIKit

struct ProfilePresentationModel {
  let header: ProfilePresentationHeaderModel
  let pinnedRepositories: [ProfilePresentationRepositoryModel]
  let topRepositories: [ProfilePresentationRepositoryModel]
  let starredRepositories: [ProfilePresentationRepositoryModel]
}

struct ProfilePresentationHeaderModel {
  let imageURL: String
  let fullName: String
  let username: String
  let email: String
  let followers: String
  let following: String
}

struct ProfilePresentationRepositoryModel {
  let authorImageURL: String
  let authorUserName: String
  let repositoryName: String
  let description: String
  let language: String
  let languageColor: UIColor
  let starCount: String
} 
