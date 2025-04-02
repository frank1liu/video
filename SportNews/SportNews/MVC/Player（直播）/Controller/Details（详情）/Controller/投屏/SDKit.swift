//
//  EventBus.swift
//  dps.ctrl
//
//  Created by myou on 2024/6/11.
//  Copyright © 2024 myou. All rights reserved.
//

import Foundation

//c语言转成swift 一般都是可空类型，使用不便，应用自己维护一个设备列表
class DmrDeviceInfo {
    var udn:String = ""
    var name:String = ""
    
    init(udn:String,name:String) {
        self.udn = udn
        self.name = name
    }
}

class SDKit {
    //用来存储设备列表
    private static var dmrDevices:[DmrDeviceInfo] = []
    
    //添加新设备
    static func addNewDevice(udn:String,name:String){
        if dmrDevices.contains(where: {$0.udn == udn}) {
            print("已存在\(udn),不添加")
        }else{
            dmrDevices.append(DmrDeviceInfo(udn:udn,name: name))
        }
    }
    //移除离线设备
    static func removeOffDevice(udn:String){
        dmrDevices.removeAll(where: {$0.udn == udn})
    }
    
    //获取列表
    static func getAllDmrDevices()-> [DmrDeviceInfo]{
        return dmrDevices;
    }

    //移除所有設備
    static func removeAllDevice() {
        dmrDevices.removeAll()
    }

    static let shared = SDKit()
    
    private init() {}
    
    private var observers = [String: [(Any) -> Void]]()
    
    func register<T>(event: String, observer: @escaping (T) -> Void) {
        if observers[event] == nil {
            observers[event] = []
        }
        observers[event]?.append { data in
            if let data = data as? T {
                observer(data)
            }
        }
    }
    
    func post(event: String, data: Any) {
        if let observersForEvent = observers[event] {
            for observer in observersForEvent {
                observer(data)
            }
        }
    }
    
    func unregister(event: String) {
        observers[event] = nil
    }
}
