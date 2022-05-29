//
//  SceneDelegate.swift
//  JustEat
//
//  Created by Hassaan Fayyaz Ahmed on 5/22/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window = UIWindow()
        window?.windowScene = scene as? UIWindowScene
        let restaurantListVM = RestaurantListViewModel(restaurantNetworkService: RestaurantNetworkSercice(networkManager: NetworkManager()))
        let restaurantListController = RestaurantListViewController.createViewController(restaurantListVM: restaurantListVM)
        let navigationController = UINavigationController(rootViewController: restaurantListController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        guard let _ = (scene as? UIWindowScene) else { return }
    }

}
