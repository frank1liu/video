//
//  EIHeaderOne.swift
//  SportNews
//
//  Created by yuhua on 2021/2/6.
//

import UIKit

class EIHeaderOne: UIView {
    
    let company = UIButton()
    let color = UIColor(red: 0x27/0xff, green: 0xc5/0xff, blue: 0xc3/0xff, alpha: 1)
    let choiceView = EIHeaderOneChoiceView.init(frame: CGRect.zero, categories: ["所有", "初", "即"], bgcolor: UIColor(red: 0x27/0xff, green: 0xc5/0xff, blue: 0xc3/0xff, alpha: 1))
    
    var choice: ((Int)->Void)? {
        didSet {
            choiceView.choiceCategoriesIndex = self.choice
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        company.layer.cornerRadius = 11.25
        company.layer.borderWidth = 1
        company.layer.borderColor = color.cgColor
        company.setTitle("公司筛选", for: .normal)
        company.setTitleColor(color, for: .normal)
        company.titleLabel?.font = .systemFont(ofSize: 11)
        company.addTarget(self, action: #selector(companySelected), for: .touchUpInside)
        addSubview(company)
        company.mas_makeConstraints {
            $0?.left.equalTo()(self)?.offset()(15)
            $0?.top.equalTo()(self)?.offset()(13)
            $0?.size.equalTo()(CGSize(width: 61.5, height: 22.5))
        }
        
        addSubview(choiceView)
        choiceView.mas_makeConstraints {
            $0?.top.bottom()?.equalTo()(company)
            $0?.right.equalTo()(self)?.offset()(-15)
            $0?.width.equalTo()(117)
        }
    }
    
    @objc func companySelected() {
        let choice = CompanyChoiceView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height - 97 * 2))
        UIHelper.shared.showModalView(content: choice)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class EIHeaderOneChoiceView: UIView {
    
    private var categories: [String]!
    private let stack = UIStackView()
    private let round = UIView()
    
    @objc var choiceCategoriesIndex: ((Int)->Void)?
    
    @objc init(frame: CGRect, categories: [String], bgcolor: UIColor) {
        super.init(frame: frame)
        
        layer.cornerRadius = 11.25
        backgroundColor = bgcolor
        self.categories = categories
        
        round.backgroundColor = .white
        round.layer.cornerRadius = 9
        addSubview(round)
        
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        categories.forEach {
            let button = UIButton()
            button.setAttributedTitle(NSAttributedString(string: $0, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)]), for: .normal)
            button.setAttributedTitle(NSAttributedString(string: $0, attributes: [NSAttributedString.Key.foregroundColor: bgcolor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.init(2))]), for: .selected)
            button.addTarget(self, action: #selector(choiceCategories(button:)), for: .touchUpInside)
            stack.addArrangedSubview(button)
        }
        addSubview(stack)
        stack.mas_makeConstraints {
            $0?.edges.equalTo()(self)
        }
        
        (stack.arrangedSubviews.first! as! UIButton).isSelected = true
        round.mas_makeConstraints {
            $0?.center.equalTo()(stack.arrangedSubviews.first!)
            $0?.height.mas_equalTo()(18)
            $0?.width.mas_equalTo()(35)
        }
    }
    
    @objc private func choiceCategories(button: UIButton) {
        if button.isSelected {
            return
        }
        stack.arrangedSubviews.forEach {
            ($0 as! UIButton).isSelected = false
        }
        choiceCategoriesIndex?(stack.arrangedSubviews.firstIndex(of: button)!)
        button.isSelected = true
        UIView.animate(withDuration: 0.1) {
            self.round.center = button.center
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
