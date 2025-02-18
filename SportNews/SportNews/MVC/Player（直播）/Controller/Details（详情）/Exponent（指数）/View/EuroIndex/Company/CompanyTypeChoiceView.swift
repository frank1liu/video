//
//  CompanyTypeChoiceView.swift
//  SportNews
//
//  Created by yuhua on 2021/2/7.
//

import UIKit

class CompanyTypeChoiceView: UIView {
    
    let b1 = QMUIButton.buildCompanyChoiceButton(normalAttr: NSAttributedString(string: "主流", attributes: [NSAttributedString.Key.foregroundColor: Color666666, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]), selectedAttr: NSAttributedString(string: "主流", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .init(2))]))
    let b2 = QMUIButton.buildCompanyChoiceButton(normalAttr: NSAttributedString(string: "交易所", attributes: [NSAttributedString.Key.foregroundColor: Color666666, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]), selectedAttr: NSAttributedString(string: "交易所", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .init(2))]))
    let b3 = QMUIButton.buildCompanyChoiceButton(normalAttr: NSAttributedString(string: "中文", attributes: [NSAttributedString.Key.foregroundColor: Color666666, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]), selectedAttr: NSAttributedString(string: "中文", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .init(2))]))
    let b4 = QMUIButton.buildCompanyChoiceButton(normalAttr: NSAttributedString(string: "数字", attributes: [NSAttributedString.Key.foregroundColor: Color666666, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]), selectedAttr: NSAttributedString(string: "数字", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .init(2))]))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(frame: CGRect(x: 8.5, y: 0, width: frame.width - 17, height: frame.height))
        stack.spacing = 8.5
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        let width = (frame.width - 8.5 * 5) / 4
        
        [b1, b2, b3, b4].forEach {
            $0.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
            $0.backgroundColor = ColorF5F5F5
            stack.addArrangedSubview($0)
        }
        addSubview(stack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
