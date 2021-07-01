//
//  AppDelegate.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import UIKit
import Then
import SnapKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = StageViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}
