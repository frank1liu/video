//
//  CompanyChoiceBottomView.swift
//  SportNews
//
//  Created by yuhua on 2021/2/7.
//

import UIKit

class CompanyChoiceBottomView: UIView {
    
    let all = QMUIButton.buildCompanyChoiceButton(normalAttr: NSAttributedString(string: "全选", attributes: [NSAttributedString.Key.foregroundColor: Color666666, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]), selectedAttr: NSAttributedString(string: "全选", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .init(2))]))
    let allNot = QMUIButton.buildCompanyChoiceButton(normalAttr: NSAttributedString(string: "全不选", attributes: [NSAttributedString.Key.foregroundColor: Color666666, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]), selectedAttr: NSAttributedString(string: "全不选", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .init(2))]))
    let sure = QMUIButton.buildCompanyChoiceButton(normalAttr: NSAttributedString(string: "确认", attributes: [NSAttributedString.Key.foregroundColor: Color666666, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]), selectedAttr: NSAttributedString(string: "确认", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .init(2))]))
    let allChoice = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = ColorF7F7F7
        
        sure.backgroundColor = Color27C5C3
        sure.isSelected = true
        sure.frame = CGRect(x: frame.width - 66 - 15, y: 10, width: 66, height: 30.5)
        addSubview(sure)
        
        allNot.backgroundColor = .white
        allNot.frame = CGRect(x: sure.frame.origin.x - 66 - 5, y: 10, width: 66, height: 30.5)
        addSubview(allNot)
        
        all.backgroundColor = .white
        all.frame = CGRect(x: allNot.frame.origin.x - 66 - 5, y: 10, width: 66, height: 30.5)
        addSubview(all)
        
        allChoice.text = "选中  (20)"
        allChoice.frame = CGRect(x: 15, y: 15.5, width: 100, height: 20)
        allChoice.textColor = Color666666
        allChoice.font = .systemFont(ofSize: 14)
        addSubview(allChoice)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
