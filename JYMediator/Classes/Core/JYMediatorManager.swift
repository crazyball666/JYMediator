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
class JYMediatorManager: NSObject {
    static var shared = JYMediatorManager()
    
    /// 是否报异常，默认为 false
    /// 重复注册服务时或注册的类没遵从注册的服务协议时，抛出异常。
    private var enableException: Bool = false
    
    /// 服务协议和实现类
    private var servicesList: [AnyClass] = []
    private var servicesDict: Dictionary = [String: AnyClass]()
    private let lock = NSRecursiveLock()
    
    func enableException(_ aBool: Bool) {
        enableException = aBool
    }
    
}

// MARK: - 协议相关
extension JYMediatorManager {
    func safeGetAllService() -> [AnyClass] {
        lock.lock()
        let list = servicesList
        lock.unlock()
        return list
    }
    
    
    func registerService(_ aProtocol: Protocol, aClass: AnyClass) {
        guard class_conformsToProtocol(aClass, aProtocol) else {
            assert(enableException == false, "\(NSStringFromClass(aClass)) module does not comply with \(NSStringFromProtocol(aProtocol)) protocol")
            return
        }
        guard !checkHasRegistered(aProtocol) else {
            assert(enableException == false, "\(NSStringFromProtocol(aProtocol)) protocol has been registed")
            return
        }
        let key = NSStringFromProtocol(aProtocol)
        if key.count > 0 {
            lock.lock()
            servicesList.append(aClass)
            servicesDict[key] = aClass
            lock.unlock()
            if let s = aClass as? JYServiceEventProtocol.Type {
                DispatchQueue.main.async {
                    s.onRegister?()
                }
            }
        }
    }
    
    func registerService(_ aProtocol: Protocol, serviceClassName: String) {
        guard let aClass = NSClassFromString(serviceClassName) else {
            assert(enableException == false, "\(serviceClassName) not exist service Class! If ignore, Please Setting `TSMediator.enableException(false)`")
            return
        }
        registerService(aProtocol, aClass: aClass)
    }
    
    func createService(_ aProtocol: Protocol) -> AnyClass? {
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
    
    func removeService(_ aProtocol: Protocol) {
        let key = NSStringFromProtocol(aProtocol)
        lock.lock()
        if let service = servicesDict[key] {
            servicesDict.removeValue(forKey: key)
            servicesList.removeAll { $0 == service }
            if let s = service as? JYServiceEventProtocol.Type {
                DispatchQueue.main.async {
                    s.onRemove?()
                }
            }
        }
        lock.unlock()
        
    }
    
    func triggerEvent(_ eventName: String, data: Any?) {
        DispatchQueue.main.async {
            self.safeGetAllService().compactMap { $0 as? JYServiceEventProtocol.Type }.forEach { service in
                service.onEvent?(eventName, data: data)
            }
        }
    }
}

// MARK: - Private Method
extension JYMediatorManager {
    private func checkHasRegistered(_ aProtocol: Protocol) -> Bool {
        lock.lock()
        let dict = servicesDict
        lock.unlock()
        let serviceKey = NSStringFromProtocol(aProtocol)
        return dict[serviceKey] != nil
    }
}
