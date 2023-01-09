
import Foundation

import UIKit

class TabbarController: UITabBarController {
    static let shared = TabbarController()
    func tabbar() -> UITabBarController {
        //Home
        let home = HomeViewController()
        let navigation = UINavigationController(rootViewController: home)
        navigation.isNavigationBarHidden = true
        home.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "img-home-image"), tag: 0)
        // Gio hang
        let far = FavoritesViewController()
        let farNavi = UINavigationController(rootViewController: far)
        farNavi.isNavigationBarHidden = true
        far.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "ima-myFav-image"), tag: 1)
        //user
        let user = UserViewController()
        let userNavi = UINavigationController(rootViewController: user)
        userNavi.isNavigationBarHidden = true
        user.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "img-about-image"), tag: 2)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            navigation,
            farNavi,
            userNavi
        ]
        return tabBarController
    }
}
