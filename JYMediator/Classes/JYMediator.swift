//
//  JYMediator.swift
//  JYMediator
//
//  Created by crazyball on 2022/2/15.
//

import Foundation


@objcMembers
@objc public class JYMediator: NSObject {
    
    /// 是否抛出异常。重复注册服务时或注册的类没遵从注册的服务协议时，抛出异常。
    /// - Parameter aBool: 是否开启
    static public func enableException(_ aBool: Bool) {
        JYMediatorManager.shared.enableException(aBool)
    }
    
    /// 注册协议
    /// - Parameters:
    ///   - aProtocol: 需要注册的协议
    ///   - aClass: 实现协议的类
    static public func registerService(_ aProtocol: Protocol, serviceClass: AnyClass) {
        JYMediatorManager.shared.registerService(aProtocol, aClass: serviceClass)
    }
    
    /// 注册协议（通过字符串）
    /// - Parameters:
    ///   - protocolName: 协议名字（注意 Swift 的命名空间）
    ///   - serviceClassName: 实现协议的类名（注意 Swift 的命名空间）
    static public func registerService(_ protocolName: String, serviceClassName: String) {
        JYMediatorManager.shared.registerService(protocolName, serviceClassName: serviceClassName)
    }
        
    /// 获取协议实现类（通过协议）
    /// - Parameter aProtocol: 服务协议
    /// - Returns: 实现协议的类。如果未注册协议，则返回空
    static public func createService(_ aProtocol: Protocol) -> AnyClass? {
        return JYMediatorManager.shared.createService(aProtocol)
    }
}
