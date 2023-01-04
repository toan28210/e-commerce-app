//
//  Application.swift
//  AppDATN
//
//  Created by Toan Tran on 04/01/2023.
//

import Foundation
import UIKit

enum State {
    case auth
    case home
}

final class Application {
    
    // MARK: - Singleton pattern
    static let shared = Application()
    
    private var window: UIWindow?
    
    private init() {}
    
    // MARK: - Configs
    func configMainInterface(with window: UIWindow?) {
        self.window = window
        setupMainInterface()
    }
    
    func setupMainInterface() {
        let userId = "\(UserDefaults.standard.value(forKey: "userid") ?? "")"
        print("userId: \(userId)")
        guard userId != ""  else {
            self.toAuth()
            return
        }
        self.toHome()
    }
    
    private func toAuth() {
        let welcome = WelcomeViewController()
        let navigationController = UINavigationController(rootViewController: welcome)
        window?.rootViewController = navigationController
    }
    
    private func toHome() {
        //Home
        let home = HomeViewController()
        let navigation = UINavigationController(rootViewController: home)
        home.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "img-home-image"), tag: 0)
        // Gio hang
        let far = FagoritesViewController()
        let farNavi = UINavigationController(rootViewController: far)
        far.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "ima-myFav-image"), tag: 1)
        //user
        let user = UserViewController()
        let userNavi = UINavigationController(rootViewController: user)
        user.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "img-about-image"), tag: 2)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            navigation,
            farNavi,
            userNavi
        ]
        window?.rootViewController = tabBarController
    }
    private func switchRootViewController(rootVC: UIViewController) {
        
    }
}

