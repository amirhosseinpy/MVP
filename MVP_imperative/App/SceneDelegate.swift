//
//  SceneDelegate.swift
//  MVP_imperative
//
//  Created by amirhosseinpy on 12/11/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  private var coordinator: RootCoordinator?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    if let windowScene = scene as? UIWindowScene {
      _ = DIAgent()
      setupWindow(windowScene: windowScene)
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) {}

  func sceneDidBecomeActive(_ scene: UIScene) {}

  func sceneWillResignActive(_ scene: UIScene) {}

  func sceneWillEnterForeground(_ scene: UIScene) {}

  func sceneDidEnterBackground(_ scene: UIScene) {}
  
  func setupWindow(windowScene: UIWindowScene) {
    window = UIWindow(windowScene: windowScene)
    coordinator = RootCoordinator(window: window!)
    coordinator?.start()
  }
}
