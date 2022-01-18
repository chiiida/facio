//
//  AppDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 27/9/2564 BE.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
        let homeViewController = HomeViewController(
            viewModel: DependencyFactory.shared.homeViewModel()
        )
        window?.rootViewController = UINavigationController(rootViewController: homeViewController)
        
        return true
    }
}
