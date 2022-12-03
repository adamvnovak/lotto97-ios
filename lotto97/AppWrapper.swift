//
//  AppWrapper.swift
//  lotto97
//
//  Created by Adam Novak on 2022/12/03.
//

import SwiftUI

@main
struct AppWrapper {
    static func main() {
        if #available(iOS 14.0, *) {
            lotto97App.main()
        } else {
            UIApplicationMain(
                CommandLine.argc,
                CommandLine.unsafeArgv,
                nil,
                NSStringFromClass(AppDelegate.self))
        }
    }
}

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let contentView = ContentView()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

//    func sceneDidDisconnect(_ scene: UIScene) { ... }
//    func sceneDidBecomeActive(_ scene: UIScene) { ... }
//    func sceneWillResignActive(_ scene: UIScene) { ... }
//    func sceneWillEnterForeground(_ scene: UIScene) { ... }
//    func sceneDidEnterBackground(_ scene: UIScene) { ... }
}
