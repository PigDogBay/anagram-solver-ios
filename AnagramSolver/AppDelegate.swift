//
//  AppDelegate.swift
//  AnagramSolver
//
//  Created by Mark Bailey on 25/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit

//@UIApplicationMain
@MainActor
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //New in 13.4, see
        //https://stackoverflow.com/questions/60848786/xcode-11-4-navigations-title-color-gone-black-from-storyboard
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "navBackground")
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = .white

        //Enable clear button on the text field
        //https://stackoverflow.com/questions/58200555/swiftui-add-clearbutton-to-textfield
        UITextField.appearance().clearButtonMode = .always

        let settings = Settings()
        settings.registerDefaultSettings()
        return true
    }
}

