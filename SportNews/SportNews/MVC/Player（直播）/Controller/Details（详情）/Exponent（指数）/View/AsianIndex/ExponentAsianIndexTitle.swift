//
//  ExponentAsianIndexTitle.swift
//  SportNews
//
//  Created by yuhua on 2021/2/6.
//

import UIKit

class ExponentAsianIndexTitle: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let company = buildLabel(title: "公司")
        addSubview(company)
        let start = buildLabel(title: "初始")
        addSubview(start)
        let now = buildLabel(title: "即时")
        addSubview(now)
        company.mas_makeConstraints {
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.left.equalTo()(self)
        }
        start.mas_makeConstraints {
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.left.equalTo()(company.mas_right)
            $0?.width.equalTo()(company)?.multipliedBy()(2)
        }
        now.mas_makeConstraints {
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.left.equalTo()(start.mas_right)
            $0?.width.equalTo()(start)
            $0?.right.equalTo()(self)
        }
        
        let line = UIView()
        line.backgroundColor = .init(red: 0xd7/0xff, green: 0xd7/0xff, blue: 0xd7/0xff, alpha: 1)
        addSubview(line)
        line.mas_makeConstraints {
            $0?.left.equalTo()(self)
            $0?.right.equalTo()(self)
            $0?.height.equalTo()(0.5)
            $0?.bottom.equalTo()(self)
        }
    }
    
    func buildLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .init(red: 0x66/255, green: 0x66/255, blue: 0x66/255, alpha: 1)
        label.font = .systemFont(ofSize: 12, weight: .init(2))
        label.textAlignment = .center
        return label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
