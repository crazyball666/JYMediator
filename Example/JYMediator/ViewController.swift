//
//  ViewController.swift
//  JYMeditor
//
//  Created by sujiahao on 04/16/2022.
//  Copyright (c) 2022 sujiahao. All rights reserved.
//

import UIKit
import JYMediator


var kk = JYMediator.createService(TestModuleProtocol.self) as? TestModuleProtocol.Type

@objc protocol TestModuleProtocol {
    static func test()
}

class TestModule: TestModuleProtocol, JYServiceEventProtocol {
    static func onApplication(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        print("应用启动啦")
    }
    
    static func test() {
        print("test")
        JYMediator.triggerEvent("xxx", data: 11)
    }
    
    static func onRegister() {
        print("模块注册")
        kk?.test()
    }
    
    static func onRemove() {
        print("模块移除")
    }
    
    static func onEvent(_ eventName: String, data: Any?) {
        print("接收到消息 \(eventName) \(data)")
        JYMediator.removeService(TestModuleProtocol.self)
    }
}











class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        test?.test()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

