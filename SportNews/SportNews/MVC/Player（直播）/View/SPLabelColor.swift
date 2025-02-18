//
//  SPLabelColor.swift
//  SportNews
//
//  Created by yuhua on 2021/4/29.
//

import Foundation
import UIKit

class TextAnimationLabel: QMUILabel {
    /// 定时器
    var link: CADisplayLink?
    /// 当前变化颜色次数
    var number = 0
    /// 总变化颜色次数
    let total = 9
    /// 颜色数组
    let colors = [
        UIColor(red: 0x55/0xff, green: 0x55/0xff, blue: 0x55/0xff, alpha: 1),
        UIColor(red: 0xa9/0xff, green: 0x55/0xff, blue: 0x55/0xff, alpha: 1),
        UIColor(red: 0xd2/0xff, green: 0x55/0xff, blue: 0x55/0xff, alpha: 1),
        UIColor(red: 0xea/0xff, green: 0x55/0xff, blue: 0x55/0xff, alpha: 1),
        UIColor(red: 0xff/0xff, green: 0x55/0xff, blue: 0x55/0xff, alpha: 1),
        UIColor(red: 0xea/0xff, green: 0x55/0xff, blue: 0x55/0xff, alpha: 1),
        UIColor(red: 0xd2/0xff, green: 0x55/0xff, blue: 0x55/0xff, alpha: 1),
        UIColor(red: 0xa9/0xff, green: 0x55/0xff, blue: 0x55/0xff, alpha: 1),
        UIColor(red: 0x55/0xff, green: 0x55/0xff, blue: 0x55/0xff, alpha: 1),
    ]
    /// 闪动前的颜色，务必要先设置，用于文字闪动结束后回到该颜色，调用buildPingLabel方法可以不设置改值
    @objc var backColor: UIColor?
    
    override static func buildPingLabel(text: String,
                               textColor: UIColor,
                               font: UIFont,
                               alignment: NSTextAlignment) -> TextAnimationLabel {
        let lable = TextAnimationLabel()
        lable.text = text
        lable.backColor = textColor
        lable.textColor = textColor
        lable.font = font
        lable.textAlignment = alignment
        return lable
    }
    
    
    /// 设置文字颜色变色
    /// - Parameters:
    ///   - text: 文字
    ///   - animation: 是否变色，设置false，则会把以前的闪动关闭掉，恢复成闪动前的颜色
    @objc func setNewText(text: String, animation: Bool = false) {
        self.text = text
        cancelLink()
        if animation {
            changeTextColor()
        }
    }
    
    private func changeTextColor() {
        link = CADisplayLink(target: self, selector: #selector(changeColor))
        link?.preferredFramesPerSecond = 4
        link?.add(to: RunLoop.current, forMode: .common)
    }
    
    @objc private func changeColor() {
        if number <= 8 && number >= 0 {
            textColor = colors[number]
        }
        number += 1
        if number >= total {
            cancelLink()
        }
    }
    
    private func cancelLink() {
        link?.invalidate()
        link = nil
        number = 0
        textColor = backColor
    }
}
