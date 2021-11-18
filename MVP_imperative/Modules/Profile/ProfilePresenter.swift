//
//  ProfilePresenter.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 15/11/2021.
//

import UIKit
import Resolver

typealias ProfileDelegate = ProfilePresenterDelegate & UIViewController

protocol ProfilePresenterDelegate: PeresenterDelegate {
  func presentProfile(profileModel: ProfilePresentationModel)
  func showFailureAlert(title: String, message: String)
}

class ProfilePresenter: Presentable {
  weak var delegate: ProfileDelegate?
  
  func setDelegate(delegate: ProfileDelegate) {
    self.delegate = delegate
  }
  
  func getProfile(isRefresh: Bool) {
    @Injected var networkAgent: NetworkAgent
    
    let profileRouter = ProfileAPIRouter()
    
    networkAgent.request(profileRouter, isRefresh: isRefresh) { [weak self] response in
      switch response {
        case .success(let model):
          guard let self = self else { return }
          let presentationModel = self.convertToPresentationModel(serverModel: model)
          self.delegate?.presentProfile(profileModel: presentationModel)
        case .failure(let error):
          self?.delegate?.showFailureAlert(title: "Feching Profile Failed!",
                                           message: error.localizedDescription)
      }
    }
  }
  
  func convertToPresentationModel(serverModel: ProfileServerModel) -> ProfilePresentationModel {
    let header = convertHeader(serverModel: serverModel)
    
    let pinnedRepositories = convertRepositories(serverRepos: serverModel.pinnedItems,
                                                 avatarURLString: serverModel.avatarUrl,
                                                 userName: serverModel.login)
    
    let topRepositories = convertRepositories(serverRepos: serverModel.topRepositories,
                                                 avatarURLString: serverModel.avatarUrl,
                                                 userName: serverModel.login)
    
    let starredRepositories = convertRepositories(serverRepos: serverModel.starredRepositories,
                                                 avatarURLString: serverModel.avatarUrl,
                                                 userName: serverModel.login)
    
    let profileModel = ProfilePresentationModel(header: header,
                                                pinnedRepositories: pinnedRepositories,
                                                topRepositories: topRepositories,
                                                starredRepositories: starredRepositories)
    
    return profileModel
  }
  
  func convertHeader(serverModel: ProfileServerModel) -> ProfilePresentationHeaderModel {
    let header = ProfilePresentationHeaderModel(imageURL: serverModel.avatarUrl ?? "",
                                    fullName: serverModel.name ?? "",
                                    username: serverModel.login ?? "",
                                    email: serverModel.email ?? "",
                                    followers: summerizeStarCount(starCount: serverModel.followers?.totalCount),
                                    following: summerizeStarCount(starCount: serverModel.following?.totalCount))
    return header
  }
  
  
  func convertRepositories(serverRepos: ProfileServerEdgesModel<ProfileServerRepositoryModel>?,
                           avatarURLString: String?,
                           userName: String?) -> [ProfilePresentationRepositoryModel] {
    var repositories = [ProfilePresentationRepositoryModel]()
    
    for repo in serverRepos?.edges ?? [] {
      let node = repo.node
      var language: ProfileServerLanguangeModel?
      
      if node?.languages.edges?.count ?? 0 > 0 {
        language = node?.languages.edges?[0].node
      }
      
      let repository = ProfilePresentationRepositoryModel(
        authorImageURL: avatarURLString ?? "",
        authorUserName: userName ?? "",
        repositoryName: node?.name ?? "",
        description: node?.description ?? "",
        language: language?.name ?? "",
        languageColor: UIColor(netHexString: language?.color ?? ""),
        starCount: summerizeStarCount(starCount: node?.stargazerCount))
      
      repositories.append(repository)
    }
    
    return repositories
  }
  
  
  func summerizeStarCount(starCount: Int?) -> String {
    guard let starCount = starCount else { return "0" }
    
    if starCount > 999 {
      let roundedOneDec = round((Double(starCount)/1000)*10.0)/10.0
      return "\(roundedOneDec)K"
      
    } else {
      return "\(starCount)"
    }
  }
}
