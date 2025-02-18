//
//  SNCountDownManager.swift
//  SportNews
//
//  Created by kkk on 2021/3/16.
//

import UIKit


class SNCountDownManager: NSObject {
    
    public static let shared = SNCountDownManager()
    
    var timer: Timer!
    
    var timeInterval: Int = 0
      
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer.invalidate()
        timer = nil
    }
    
    @objc func timeAction() {
        timeInterval += 1
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: KCountDownNotification), object: nil)
    }
    
    func reload() {
        timeInterval = 0
    }
    
    
}
