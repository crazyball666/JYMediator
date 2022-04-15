//
//  JYMediatorManager.swift
//  JYMediator
//
//  Created by crazyball on 2022/2/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import Foundation


@objcMembers
public class JYMediatorManager: NSObject {
    
    public static var shared = JYMediatorManager()
    
    /// 是否报异常，默认为 false
    /// 重复注册服务时或注册的类没遵从注册的服务协议时，抛出异常。
    private var enableException: Bool = false
    
    /// 服务协议和实现类
    private var servicesDict: Dictionary = [String: AnyClass]()
    private let lock = NSRecursiveLock()
    
    func enableException(_ aBool: Bool) {
        enableException = aBool
    }
    
}

// MARK: - 协议相关
extension JYMediatorManager {
    
    func registerService(_ aProtocol: Protocol, aClass: AnyClass) {
                
        guard class_conformsToProtocol(aClass, aProtocol) else {
            assert(enableException == false, "\(NSStringFromClass(aClass)) module does not comply with \(NSStringFromProtocol(aProtocol)) protocol")
            return
        }
        
        guard !checkValidService(aProtocol) else {
            assert(enableException == false, "\(NSStringFromProtocol(aProtocol)) protocol has been registed")
            return
        }
        
        let key = NSStringFromProtocol(aProtocol)
        if key.count > 0 {
            lock.lock()
            servicesDict[key] = aClass
            lock.unlock()
        }
    }
    
    func registerService(_ protocolName: String, serviceClassName: String) {
        guard let aProtocol = NSProtocolFromString(protocolName) else {
            assert(enableException == false, "\(protocolName) not exist service Protocol! If ignore,Please Setting `TSMediator.enableException(false)`")
            return
        }
        guard let aClass = NSClassFromString(serviceClassName) else {
            assert(enableException == false, "\(serviceClassName) not exist service Class! If ignore,Please Setting `TSMediator.enableException(false)`")
            return
        }
        
        registerService(aProtocol, aClass: aClass)
    }
    
    func createService(_ aProtocol:Protocol) -> AnyClass? {
        
        lock.lock()
        let dict = servicesDict
        lock.unlock()
        
        let key = NSStringFromProtocol(aProtocol)
        guard let serviceClass = dict[key] else {
            assert(enableException == false, "\(NSStringFromProtocol(aProtocol)) protocol does not been registed")
            return nil
        }
        
        return serviceClass
    }
}

// MARK: - App Event 相关
extension JYMediatorManager {
    /// application 事件响应
    /// - Parameter eventType: 事件类型
    public func triggerEvent(_ eventType: JYAppEventType, context: JYAppEventContext) {
        guard let sel = JYAppEventContext.selectorDict[eventType] else {
            return
        }
        
        lock.lock()
        let dict = servicesDict
        lock.unlock()
        // 遍历所有注册的协议类
        dict.forEach { (key: String, aClass: AnyClass) in
            // Application 事件协议
            let aProtocol = JYAppEventProtocol.self
            // 注册的服务类实现了 TSApplicationProtocol 协议，并且实现协议的方法
            if class_conformsToProtocol(aClass, aProtocol), let myClass = aClass as AnyObject as? NSObjectProtocol, myClass.responds(to: sel) {
                myClass.perform(sel, with: context)
            }
        }
    }
    
}


// MARK: - Private Method
extension JYMediatorManager {
    
    private func checkValidService(_ aProtocol: Protocol) -> Bool {
        lock.lock()
        let dict = servicesDict
        lock.unlock()
        
        let serviceKey = NSStringFromProtocol(aProtocol)
        guard dict[serviceKey] != nil else {
            return false
        }
        
        return true
    }
}
