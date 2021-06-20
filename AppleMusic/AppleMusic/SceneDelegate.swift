//
//  SceneDelegate.swift
//  AppleMusic
//
//  Created by tino又想吃肉了 on 2021/6/16.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
//        let docPath = Bundle.main.path(forResource: "不为谁而作的歌", ofType: "flac")
//        let models = [SongModel("不为谁而作的歌", "林俊杰", docPath + "/林俊杰 - 不为谁而作的歌.flac", albumImage: "1"),SongModel("逃亡", "孙燕姿", docPath + "/孙燕姿 - 逃亡.flac", albumImage: "2")]
        let models = [SongModel("不为谁而作的歌","林俊杰",Bundle.main.path(forResource: "/Music/林俊杰 - 不为谁而作的歌.flac", ofType: nil) ?? "",albumImage: "1")
            ,SongModel("逃亡", "孙燕姿", Bundle.main.path(forResource: "/Music/孙燕姿 - 逃亡.flac", ofType: nil) ?? "", albumImage: "2")]
        
        let vc = TabBarController()
        vc.model = models
        
        window?.rootViewController = vc
        
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

