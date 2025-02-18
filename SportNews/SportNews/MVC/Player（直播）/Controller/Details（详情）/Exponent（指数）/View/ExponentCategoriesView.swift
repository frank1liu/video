//
//  ExponentCategoriesView.swift
//  SportNews
//
//  Created by yuhua on 2021/2/5.
//

import UIKit
import Masonry

class ExponentCategoriesView: UIView {
    
    private var categories: [String]!
    private let stack = UIStackView()
    private let round = UIView()
    
    @objc var current = 0
    
    @objc var choiceCategoriesIndex: ((Int)->Void)?
    
    @objc init(frame: CGRect, categories: [String]) {
        super.init(frame: frame)
        
        layer.cornerRadius = 20
        backgroundColor = UIColor(red: 0xe4/255.0, green: 0xe4/255.0, blue: 0xe4/255.0, alpha: 1)
        self.categories = categories
        
        round.backgroundColor = .white
        round.layer.cornerRadius = 16
        addSubview(round)
        
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        categories.forEach {
            let button = UIButton()
            button.setAttributedTitle(NSAttributedString(string: $0, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0x66/255.0, green: 0x66/255.0, blue: 0x66/255.0, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]), for: .normal)
            button.setAttributedTitle(NSAttributedString(string: $0, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0x27/255.0, green: 0xc5/255.0, blue: 0xc3/255.0, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.init(2))]), for: .selected)
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
            $0?.height.mas_equalTo()(32)
            $0?.width.mas_equalTo()(categories.count == 4 ? 82 : 110)
        }
    }
    
    @objc private func choiceCategories(button: UIButton) {
        if button.isSelected {
            return
        }
        stack.arrangedSubviews.forEach {
            ($0 as! UIButton).isSelected = false
        }
        current = stack.arrangedSubviews.firstIndex(of: button)!
        choiceCategoriesIndex?(current)
        button.isSelected = true
        UIView.animate(withDuration: 0.1) {
            self.round.center = button.center
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
