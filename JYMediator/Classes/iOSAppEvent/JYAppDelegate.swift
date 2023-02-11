//
//  JYAppDelegate.swift
//  JYMediator
//
//  Created by crazyball on 2023/2/11.
//

import UIKit

// MARK: App 代理方法回调
@objc public protocol JYAppEventProtocol {
    @objc optional static func onApplication(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?)
    @objc optional static func onApplicationDidBecomeActive(_ application: UIApplication)
    @objc optional static func onApplicationWillResignActive(_ application: UIApplication)
    @objc optional static func onApplicationDidEnterBackground(_ application: UIApplication)
    @objc optional static func onApplicationWillEnterForeground(_ application: UIApplication)
    @objc optional static func onApplicationWillTerminate(_ application: UIApplication)
    @objc optional static func onApplicationDidReceiveMemoryWarning(_ application: UIApplication)
    @objc optional static func onApplication(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    @objc optional static func onApplication(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any)
    @objc optional static func onApplication(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void)
    @objc optional static func onApplication(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    @objc optional static func onApplication(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
}

fileprivate extension JYMediator {
    static var allAppEventService: [JYAppEventProtocol.Type] {
        JYMediator.services.compactMap { $0 as? JYAppEventProtocol.Type }
    }
}


// MARK: - App 代理类
@objcMembers
@objc class JYAppDelegate: NSObject {
    static func startHook() {
        JYMDHooker.hookInstanceMethod(UIApplication.self, originalSel: NSSelectorFromString("setDelegate:"), replacedClass: self, replacedSel: #selector(JYAppDelegate.JYSetDelegate(_:)), noneSel: #selector(JYAppDelegate.JYNoneSetDelegate(_:)))
    }
    
    dynamic func JYSetDelegate(_ delegate: NSObject) {
        JYMDHooker.hookInstanceMethod(
            delegate.classForCoder,
            originalSel: NSSelectorFromString("application:didFinishLaunchingWithOptions:"),
            replacedClass: JYAppDelegate.self,
            replacedSel: #selector(JYAppDelegate.jymd_hook_application(_:didFinishLaunchingWithOptions:)),
            noneSel: #selector(JYAppDelegate.jymd_none_application(_:didFinishLaunchingWithOptions:))
        )
        JYMDHooker.hookInstanceMethod(
            delegate.classForCoder,
            originalSel: NSSelectorFromString("applicationDidBecomeActive:"),
            replacedClass: JYAppDelegate.self,
            replacedSel: #selector(JYAppDelegate.jymd_hook_applicationDidBecomeActive(_:)),
            noneSel: #selector(JYAppDelegate.jymd_none_applicationDidBecomeActive(_:))
        )
        JYMDHooker.hookInstanceMethod(
            delegate.classForCoder,
            originalSel: NSSelectorFromString("applicationWillResignActive:"),
            replacedClass: JYAppDelegate.self,
            replacedSel: #selector(JYAppDelegate.jymd_hook_applicationWillResignActive(_:)),
            noneSel: #selector(JYAppDelegate.jymd_none_applicationWillResignActive(_:))
        )
        JYMDHooker.hookInstanceMethod(
            delegate.classForCoder,
            originalSel: NSSelectorFromString("applicationDidEnterBackground:"),
            replacedClass: JYAppDelegate.self,
            replacedSel: #selector(JYAppDelegate.jymd_hook_applicationDidEnterBackground(_:)),
            noneSel: #selector(JYAppDelegate.jymd_none_applicationDidEnterBackground(_:))
        )
        JYMDHooker.hookInstanceMethod(
            delegate.classForCoder,
            originalSel: NSSelectorFromString("applicationWillEnterForeground:"),
            replacedClass: JYAppDelegate.self,
            replacedSel: #selector(JYAppDelegate.jymd_hook_applicationDidEnterBackground(_:)),
            noneSel: #selector(JYAppDelegate.jymd_none_applicationDidEnterBackground(_:))
        )
        JYMDHooker.hookInstanceMethod(
            delegate.classForCoder,
            originalSel: NSSelectorFromString("applicationWillTerminate:"),
            replacedClass: JYAppDelegate.self,
            replacedSel: #selector(JYAppDelegate.jymd_hook_applicationWillTerminate(_:)),
            noneSel: #selector(JYAppDelegate.jymd_none_applicationWillTerminate(_:))
        )
        JYMDHooker.hookInstanceMethod(
            delegate.classForCoder,
            originalSel: NSSelectorFromString("applicationDidReceiveMemoryWarning:"),
            replacedClass: JYAppDelegate.self,
            replacedSel: #selector(JYAppDelegate.jymd_hook_applicationDidReceiveMemoryWarning(_:)),
            noneSel: #selector(JYAppDelegate.jymd_none_applicationDidReceiveMemoryWarning(_:))
        )
        JYMDHooker.hookInstanceMethod(
            delegate.classForCoder,
            originalSel: NSSelectorFromString("application:openURL:options:"),
            replacedClass: JYAppDelegate.self,
            replacedSel: #selector(JYAppDelegate.jymd_hook_application(_:open:options:)),
            noneSel: #selector(JYAppDelegate.jymd_none_application(_:open:options:))
        )
        JYMDHooker.hookInstanceMethod(
            delegate.classForCoder,
            originalSel: NSSelectorFromString("application:openURL:sourceApplication:annotation:"),
            replacedClass: JYAppDelegate.self,
            replacedSel: #selector(JYAppDelegate.jymd_hook_application(_:open:sourceApplication:annotation:)),
            noneSel: #selector(JYAppDelegate.jymd_none_application(_:open:sourceApplication:annotation:))
        )
        JYMDHooker.hookInstanceMethod(
            delegate.classForCoder,
            originalSel: NSSelectorFromString("application:continueUserActivity:restorationHandler:"),
            replacedClass: JYAppDelegate.self,
            replacedSel: #selector(JYAppDelegate.jymd_hook_application(_:continue:restorationHandler:)),
            noneSel: #selector(JYAppDelegate.jymd_none_application(_:continue:restorationHandler:))
        )
        JYMDHooker.hookInstanceMethod(
            delegate.classForCoder,
            originalSel: NSSelectorFromString("application:didRegisterForRemoteNotificationsWithDeviceToken:"),
            replacedClass: JYAppDelegate.self,
            replacedSel: #selector(JYAppDelegate.jymd_hook_application(_:didRegisterForRemoteNotificationsWithDeviceToken:)),
            noneSel: #selector(JYAppDelegate.jymd_none_application(_:didRegisterForRemoteNotificationsWithDeviceToken:))
        )
        JYMDHooker.hookInstanceMethod(
            delegate.classForCoder,
            originalSel: NSSelectorFromString("application:didReceiveRemoteNotification:fetchCompletionHandler:"),
            replacedClass: JYAppDelegate.self,
            replacedSel: #selector(JYAppDelegate.jymd_hook_application(_:didReceiveRemoteNotification:fetchCompletionHandler:)),
            noneSel: #selector(JYAppDelegate.jymd_none_application(_:didReceiveRemoteNotification:fetchCompletionHandler:))
        )
        JYSetDelegate(delegate)
    }
    
    dynamic func JYNoneSetDelegate(_ delegate: UIApplicationDelegate) {}
}

// MARK: - App 代理hook方法
extension JYAppDelegate {
    dynamic func jymd_hook_application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        JYLog("[Hook] Hook app did finish launching with options")
        let res = jymd_hook_application(application, didFinishLaunchingWithOptions: launchOptions)
        DispatchQueue.main.async {
            JYMediator.allAppEventService.forEach { service in
                service.onApplication?(application, didFinishLaunchingWithOptions: launchOptions)
            }
        }
        return res
    }
    
    dynamic func jymd_hook_applicationDidBecomeActive(_ application: UIApplication) {
        JYLog("[Hook] Hook app did become active")
        jymd_hook_applicationDidBecomeActive(application)
        DispatchQueue.main.async {
            JYMediator.allAppEventService.forEach { service in
                service.onApplicationDidBecomeActive?(application)
            }
        }
    }
    
    dynamic func jymd_hook_applicationWillResignActive(_ application: UIApplication) {
        JYLog("[Hook] Hook app will resign active")
        jymd_hook_applicationWillResignActive(application)
        DispatchQueue.main.async {
            JYMediator.allAppEventService.forEach { service in
                service.onApplicationWillResignActive?(application)
            }
        }
    }
    
    dynamic func jymd_hook_applicationDidEnterBackground(_ application: UIApplication) {
        JYLog("[Hook] Hook app did enter background")
        jymd_hook_applicationDidEnterBackground(application)
        DispatchQueue.main.async {
            JYMediator.allAppEventService.forEach { service in
                service.onApplicationDidEnterBackground?(application)
            }
        }
    }
    
    dynamic func jymd_hook_applicationWillEnterForeground(_ application: UIApplication) {
        JYLog("[Hook] Hook app will enter foreground")
        jymd_hook_applicationWillEnterForeground(application)
        DispatchQueue.main.async {
            JYMediator.allAppEventService.forEach { service in
                service.onApplicationWillEnterForeground?(application)
            }
        }
    }
    
    dynamic func jymd_hook_applicationWillTerminate(_ application: UIApplication) {
        JYLog("[Hook] Hook app will terminate")
        jymd_hook_applicationWillTerminate(application)
        DispatchQueue.main.async {
            JYMediator.allAppEventService.forEach { service in
                service.onApplicationWillTerminate?(application)
            }
        }
    }
    
    dynamic func jymd_hook_applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        JYLog("[Hook] Hook app did receive memory warning")
        jymd_hook_applicationDidReceiveMemoryWarning(application)
        DispatchQueue.main.async {
            JYMediator.allAppEventService.forEach { service in
                service.onApplicationDidReceiveMemoryWarning?(application)
            }
        }
    }
    
    dynamic func jymd_hook_application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        JYLog("[Hook] Hook app open url with options")
        let res = jymd_hook_application(app, open: url, options: options)
        DispatchQueue.main.async {
            JYMediator.allAppEventService.forEach { service in
                service.onApplication?(app, open: url, options: options)
            }
        }
        return res
    }
    
    dynamic func jymd_hook_application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        JYLog("[Hook] Hook app open url with source application and annotation")
        let res = jymd_hook_application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        DispatchQueue.main.async {
            JYMediator.allAppEventService.forEach { service in
                service.onApplication?(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
            }
        }
        return res
    }
    
    dynamic func jymd_hook_application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        JYLog("[Hook] Hook app continue restorationHandler")
        let res = jymd_hook_application(application, continue: userActivity, restorationHandler: restorationHandler)
        DispatchQueue.main.async {
            JYMediator.allAppEventService.forEach { service in
                service.onApplication?(application, continue: userActivity, restorationHandler: restorationHandler)
            }
        }
        return res
    }
    
    dynamic func jymd_hook_application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JYLog("[Hook] Hook app did register remote notification with device token")
        jymd_hook_application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        DispatchQueue.main.async {
            JYMediator.allAppEventService.forEach { service in
                service.onApplication?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
            }
        }
    }
    
    dynamic func jymd_hook_application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JYLog("[Hook] Hook app did receive remote notification")
        jymd_hook_application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        DispatchQueue.main.async {
            JYMediator.allAppEventService.forEach { service in
                service.onApplication?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
            }
        }
    }
}


// MARK: - App 代理空方法
extension JYAppDelegate {
    dynamic func jymd_none_application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        JYLog("[Hook] none \(#function)")
        return true
    }
    
    dynamic func jymd_none_applicationDidBecomeActive(_ application: UIApplication) {
        JYLog("[Hook] none \(#function)")
    }
    
    dynamic func jymd_none_applicationWillResignActive(_ application: UIApplication) {
        JYLog("[Hook] none \(#function)")
    }
    
    dynamic func jymd_none_applicationDidEnterBackground(_ application: UIApplication) {
        JYLog("[Hook] none \(#function)")
    }
    
    dynamic func jymd_none_applicationWillEnterForeground(_ application: UIApplication) {
        JYLog("[Hook] none \(#function)")
    }
    
    dynamic func jymd_none_applicationWillTerminate(_ application: UIApplication) {
        JYLog("[Hook] none \(#function)")
    }
    
    dynamic func jymd_none_applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        JYLog("[Hook] none \(#function)")
    }
    
    dynamic func jymd_none_application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        JYLog("[Hook] none \(#function)")
        return true
    }
    
    dynamic func jymd_none_application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        JYLog("[Hook] none \(#function)")
        return true
    }
    
    dynamic func jymd_none_application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        JYLog("[Hook] none \(#function)")
        return true
    }
    
    dynamic func jymd_none_application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JYLog("[Hook] none \(#function)")
    }
    
    dynamic func jymd_none_application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.noData)
        JYLog("[Hook] none \(#function)")
    }
    
    dynamic func jymd_none_application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIApplication.shared.supportedInterfaceOrientations(for: window)
    }
}
