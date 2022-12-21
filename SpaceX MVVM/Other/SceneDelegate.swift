//
//  SceneDelegate.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/5/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow.init(windowScene: windowScene)
        window?.backgroundColor = .black
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: MainPageVC())
    }
}
