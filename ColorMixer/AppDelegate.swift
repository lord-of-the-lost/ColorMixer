//
//  AppDelegate.swift
//  ColorMixer
//
//  Created by Николай Игнатов on 21.01.2025.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = ColorMixerViewController()
        window.makeKeyAndVisible()
        return true
    }
}

