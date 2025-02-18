//
//  CompanyTypeAZView.swift
//  SportNews
//
//  Created by yuhua on 2021/2/7.
//

import UIKit

class CompanyTypeAZView: UIView {
    
    let ad = QMUIButton.buildCompanyChoiceButton(normalAttr: NSAttributedString(string: "A-D", attributes: [NSAttributedString.Key.foregroundColor: Color666666, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]), selectedAttr: NSAttributedString(string: "A-D", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .init(2))]))
    let eh = QMUIButton.buildCompanyChoiceButton(normalAttr: NSAttributedString(string: "E-H", attributes: [NSAttributedString.Key.foregroundColor: Color666666, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]), selectedAttr: NSAttributedString(string: "E-H", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .init(2))]))
    let il = QMUIButton.buildCompanyChoiceButton(normalAttr: NSAttributedString(string: "I-L", attributes: [NSAttributedString.Key.foregroundColor: Color666666, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]), selectedAttr: NSAttributedString(string: "I-L", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .init(2))]))
    let mp = QMUIButton.buildCompanyChoiceButton(normalAttr: NSAttributedString(string: "M-P", attributes: [NSAttributedString.Key.foregroundColor: Color666666, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]), selectedAttr: NSAttributedString(string: "M-P", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .init(2))]))
    let qt = QMUIButton.buildCompanyChoiceButton(normalAttr: NSAttributedString(string: "Q-T", attributes: [NSAttributedString.Key.foregroundColor: Color666666, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]), selectedAttr: NSAttributedString(string: "Q-T", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .init(2))]))
    let uz = QMUIButton.buildCompanyChoiceButton(normalAttr: NSAttributedString(string: "U-Z", attributes: [NSAttributedString.Key.foregroundColor: Color666666, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]), selectedAttr: NSAttributedString(string: "U-Z", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .init(2))]))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(frame: CGRect(x: 6.5, y: 0, width: frame.width - 13, height: frame.height))
        stack.spacing = 6.5
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        let width = (frame.width - 6.5 * 7) / 6
        
        [ad, eh, il, mp, qt, uz].forEach {
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
