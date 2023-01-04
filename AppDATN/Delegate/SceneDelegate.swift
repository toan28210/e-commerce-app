//
//  SceneDelegate.swift
//  AppDATN
//
//  Created by Toan Tran on 05/12/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let userDefault = UserDefaults.standard

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        var startApp = UIViewController()
        if UserDefaults.standard.hasOnboarded {
            //Home
            let tabbarController = UITabBarController()
            //Home
            let home = HomeViewController()
            let navigation = UINavigationController(rootViewController: home)
            home.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "img-home-image"), tag: 0)
            // Gio hang
            let far = FavoritesViewController()
            let farNavi = UINavigationController(rootViewController: far)
            far.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "ima-myFav-image"), tag: 1)
            //user
            let user = UserViewController()
            let userNavi = UINavigationController(rootViewController: user)
            user.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "img-about-image"), tag: 2)
            tabbarController.viewControllers = [navigation, farNavi, userNavi]
            tabbarController.tabBar.backgroundColor = .white
            let userId = UserDefaults.standard.value(forKey: "userid") ?? ""
            let checkUserId = "\(userId)"
            if checkUserId == "" {
                let login = LoginViewController()
                let navigation = UINavigationController(rootViewController: login)
                startApp = navigation
            } else {
                startApp = tabbarController
            }
        } else {
            //Onboard
            let onboard = StartViewController()
            let navigation = UINavigationController(rootViewController: onboard)
            startApp = navigation
        }
        setupButtonBackNavigation()
        window?.rootViewController = startApp
        window?.makeKeyAndVisible()
        
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    func setupButtonBackNavigation() {
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "img-back-image")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "img-back-image")
    }
}

