//
//  QMUIHelper.swift
//  SportNews
//
//  Created by yuhua on 2021/2/7.
//

import Foundation
import QMUIKit


let Color666666 = UIColor(red: 0x66/0xff, green: 0x66/0xff, blue: 0x66/0xff, alpha: 1)
let ColorF7F7F7 = UIColor(red: 0xf7/0xff, green: 0xf7/0xff, blue: 0xf7/0xff, alpha: 1)
let ColorF0F0F0 = UIColor(red: 0xf0/0xff, green: 0xf0/0xff, blue: 0xf0/0xff, alpha: 1)
let Color27C5C3 = UIColor(red: 0x27/0xff, green: 0xc5/0xff, blue: 0xc3/0xff, alpha: 1)
let ColorF5F5F5 = UIColor(red: 0xf5/0xff, green: 0xf5/0xff, blue: 0xf5/0xff, alpha: 1)
let ColorFBFBFB = UIColor(red: 0xfb/0xff, green: 0xfb/0xff, blue: 0xfb/0xff, alpha: 1)
let Color73D9D8 = UIColor(red: 0x73/0xff, green: 0xd9/0xff, blue: 0xd8/0xff, alpha: 1)
let ColorDA4155 = UIColor(red: 0xda/0xff, green: 0x41/0xff, blue: 0x55/0xff, alpha: 1)
let Color333333 = UIColor(red: 0x33/0xff, green: 0x33/0xff, blue: 0x33/0xff, alpha: 1)
let Color979797 = UIColor(red: 0x97/0xff, green: 0x97/0xff, blue: 0x97/0xff, alpha: 1)
let ColorEAEAEA = UIColor(red: 0xea/0xff, green: 0xea/0xff, blue: 0xea/0xff, alpha: 1)
let Color555555 = UIColor(red: 0x55/0xff, green: 0x55/0xff, blue: 0x55/0xff, alpha: 1)
let ColorEDFCF8 = UIColor(red: 0xed/0xff, green: 0xfc/0xff, blue: 0xf8/0xff, alpha: 1)
let ColorD6D6D6 = UIColor(red: 0xd6/0xff, green: 0xd6/0xff, blue: 0xd6/0xff, alpha: 1)
let ColorECFBF9 = UIColor(red: 0xec/0xff, green: 0xfb/0xff, blue: 0xf9/0xff, alpha: 1)
let Color4BCDCB = UIColor(red: 0x4b/0xff, green: 0xcd/0xff, blue: 0xcb/0xff, alpha: 1)
let Color19ABF5 = UIColor(red: 0x19/0xff, green: 0xab/0xff, blue: 0xf5/0xff, alpha: 1)
let Color68FF87 = UIColor(red: 0x68/0xff, green: 0xFF/0xff, blue: 0x87/0xff, alpha: 1)


/// 指数详情接口
let ExponentDetailAPI = "match/detail/exponent/change"


extension UIView {
    func randomBackgroundColor() {
        backgroundColor = QMUIThemeColor.qmui_random()
    }
    func addGradientLayer(colors: [UIColor], frame: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = frame
        gradientLayer.zPosition = -1
        layer.addSublayer(gradientLayer)
    }
}


extension Date {
    /// 转换成时间字符串
    /// - Parameter format: 格式，如yyyy-MM-dd HH:mm:ss
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    /// 字符串转date
    func toDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    /// 去掉字符串首个0
    func removeFirt0() -> String {
        if self.count >= 2 && self.first == "0" {
            return String(self.last!)
        }
        return self
    }
}

class UIHelper {
    static let shared = UIHelper()
    
    var show: QMUIModalPresentationViewController?
    
    func showModalView(content: UIView) {
        let showView = QMUIModalPresentationViewController()
        showView.contentView = content
        showView.addUpToDwonAnimation()
        showView.showWith(animated: true, completion: nil)
        show = showView
    }
    
    func hideModalView() {
        show?.hideWith(animated: true, completion: nil)
    }
    
    func showDownToUpModalView(content: UIView) {
        let showView = QMUIModalPresentationViewController()
        let frame = content.frame
        showView.contentView = content
        showView.addDownToUpAnimation()
        showView.showWith(animated: true, completion: nil)
        showView.layoutBlock = { _, _, _ in
            content.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-frame.height, width: frame.width, height: frame.height)
        }
        show = showView
    }
}


extension QMUILabel {
    @objc class func buildPingLabel(text: String,
                               textColor: UIColor,
                               font: UIFont,
                               alignment: NSTextAlignment) -> QMUILabel {
        let lable = QMUILabel()
        lable.text = text
        lable.textColor = textColor
        lable.font = font
        lable.textAlignment = alignment
        return lable
    }
}


extension QMUIButton {
    
    static func buildPingButton(text: String) -> QMUIButton {
        let button = QMUIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(Color333333, for: .normal)
        button.setTitleColor(Color27C5C3, for: .selected)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }
    
    static func buildCompanyChoiceButton(normalAttr: NSAttributedString, selectedAttr: NSAttributedString) -> QMUIButton {
        let button = QMUIButton()
        button.setAttributedTitle(normalAttr, for: .normal)
        button.setAttributedTitle(selectedAttr, for: .selected)
        button.layer.cornerRadius = 15.25
        return button
    }
}


extension QMUIModalPresentationViewController {
    
    /// 增加从上往下的动画
    func addUpToDwonAnimation() {
        showingAnimation = { [weak self] _, _, _, contentViewFrame, completion in
            self?.dimmingView?.alpha = 0
            self?.contentView?.frame = CGRectSetY(contentViewFrame, -contentViewFrame.height)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self?.dimmingView?.alpha = 1
                self?.contentView?.frame = contentViewFrame
            } completion: { finished in
                completion(finished)
            }
        }
        hidingAnimation = { [weak self] _, _, _, completion in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self?.dimmingView?.alpha = 0
                self?.contentView?.frame = CGRectSetY(self?.contentView?.frame ?? .zero, -(self?.contentView?.frame.height ?? 0))
            } completion: { finished in
                completion(finished)
            }

        }
    }
    
    /// 增加从下往上的动画
    func addDownToUpAnimation() {
        showingAnimation = { [weak self] _, _, _, contentViewFrame, completion in
            self?.dimmingView?.alpha = 0
            self?.contentView?.frame = CGRectSetY(contentViewFrame, contentViewFrame.height * 2)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self?.dimmingView?.alpha = 1
                self?.contentView?.frame = contentViewFrame
            } completion: { finished in
                completion(finished)
            }
        }
        hidingAnimation = { [weak self] _, _, _, completion in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self?.dimmingView?.alpha = 0
                self?.contentView?.frame = CGRectSetY(self?.contentView?.frame ?? .zero, 2 * (self?.contentView?.frame.height ?? 0))
            } completion: { finished in
                completion(finished)
            }

        }
    }
    
    /// 增加从左往右的动画
    func addLeftToRightAnimation() {
        showingAnimation = { [weak self] _, _, _, contentViewFrame, completion in
            self?.dimmingView?.alpha = 0
            self?.contentView?.frame = CGRectSetX(contentViewFrame, -contentViewFrame.width)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self?.dimmingView?.alpha = 1
                self?.contentView?.frame = contentViewFrame
            } completion: { finished in
                completion(finished)
            }
        }
        hidingAnimation = { [weak self] _, _, _, completion in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self?.dimmingView?.alpha = 0
                self?.contentView?.frame = CGRectSetX(self?.contentView?.frame ?? .zero, -(self?.contentView?.frame.width ?? 0))
            } completion: { finished in
                completion(finished)
            }

        }
    }
}
