//
//  JYMediatorEventProtocol.swift
//  JYMeditor
//
//  Created by crazyball on 2022/4/16.
//

import Foundation
import UIKit

/// app 事件类型
@objc public enum JYAppEventType: Int {
    case didFinishLaunchingEvent
    case didBecomeActiveEvent
    case willResignActiveEvent
    case didEnterBackgroundEvent
    case willEnterForegroundEvent
    case willTerminateEvent
    case didReceiveMemoryWarningEvent
    case openURLEvent
    case continueUserActivityEvent
}

@objcMembers
public class JYAppEventContext: NSObject {
    /// app Selector
    internal static var selectorDict: [JYAppEventType: Selector] = {
        [.didFinishLaunchingEvent: Selector(("appDidFinishLaunch:")),
         .didBecomeActiveEvent: Selector(("appDidBecomeActive:")),
         .willResignActiveEvent: Selector(("appWillResignActive:")),
         .didEnterBackgroundEvent: Selector(("appDidEnterBackground:")),
         .willEnterForegroundEvent: Selector(("appWillEnterForeground:")),
         .willTerminateEvent: Selector(("appWillTerminate:")),
         .didReceiveMemoryWarningEvent: Selector(("appDidReceiveMemoryWarning:")),
         .openURLEvent: Selector(("appOpenURL:")),
         .continueUserActivityEvent: Selector(("appContinueUserActivity:")),
        ]
    }()
    
    
    /// application
    public var application: UIApplication?
    
    /// launchOptions
    public var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    /// openURL
    public var openURL: URL?
    
    /// openURLOptions
    ///
    /// let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication]
    /// let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
    public var openURLOptions: [UIApplication.OpenURLOptionsKey : Any]?

    /// UserActivity
    public var continueUserActivity: NSUserActivity?
    
    public var continueUserActivityHandler: (([UIUserActivityRestoring]?) -> Void)?
    
    
    /// copy outside
    public override func copy() -> Any {
        let context = JYAppEventContext()
        context.application = self.application
        context.launchOptions = self.launchOptions
        context.openURL = self.openURL
        context.openURLOptions = self.openURLOptions
        context.continueUserActivity = self.continueUserActivity
        context.continueUserActivityHandler = self.continueUserActivityHandler
        return context
    }
    
}



@objc public protocol JYAppEventProtocol {
    /// App 已启动
    ///
    /// Tells the delegate that the launch process is almost done and the app is almost ready to run.
    /// application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
    @objc optional static func appDidFinishLaunch(_ context: JYAppEventContext)
    
    /// App 已激活
    ///
    /// Tells the delegate that the app has become active.
    @objc optional static func appDidBecomeActive(_ context: JYAppEventContext)
    
    /// App 即将变为非活动状态
    ///
    /// Tells the delegate that the app is about to become inactive.
    @objc optional static func appWillResignActive(_ context: JYAppEventContext)
    
    /// App 现已进入后台
    ///
    /// Tells the delegate that the app is now in the background.
    @objc optional static func appDidEnterBackground(_ context: JYAppEventContext)

    /// App 即将进入前台
    ///
    /// Tells the delegate that the app is about to enter the foreground.
    @objc optional static func appWillEnterForeground(_ context: JYAppEventContext)
    
    /// App 即将终止(结束)
    ///
    /// Tells the delegate when the app is about to terminate.
    @objc optional static func appWillTerminate(_ context: JYAppEventContext)
    
    
    /// App 收到来自系统的内存警告，需要 app 清除无用内存。
    ///
    /// Tells the delegate when the app receives a memory warning from the system.
    @objc optional static func appDidReceiveMemoryWarning(_ context: JYAppEventContext)
    
    
    /// 打开由 URL 指定的资源，并提供启动可选的字典内容。
    ///
    /// 要求代理打开由 URL 指定的资源，并提供启动可选的字典。(Asks the delegate to open a resource specified by a URL, and provides a dictionary of launch options.)
    /// 弃用：application:openURL:sourceApplication:annotation:
    ///
    /// application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    /// url: 要打开的 URL 资源
    /// options:  URL 处理可选的字典。
    /// struct UIApplication.OpenURLOptionsKey：打开 URL 时用于访问选项字典中的值的键。
    ///
    @objc optional static func appOpenURL(_ context: JYAppEventContext)
    
    /// 继续活动的数据是否可用
    ///
    /// 告诉代理继续活动的数据可用。(Tells the delegate that the data for continuing an activity is available.)
    ///
    /// application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: (([UIUserActivityRestoring]?) -> Void))
    /// userActivity: 包含与用户正在执行的任务相关联的数据的活动对象。使用这些数据继续用户在您的 iOS 应用中的活动。
    /// restorationHandler: 如果您的 app 创建对象来执行用户正在执行的任务，则要执行的块。
    ///
    @objc optional static func appContinueUserActivity(_ context: JYAppEventContext)
}
