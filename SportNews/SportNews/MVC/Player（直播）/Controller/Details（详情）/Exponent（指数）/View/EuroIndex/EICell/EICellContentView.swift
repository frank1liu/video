//
//  EICellContentView.swift
//  SportNews
//
//  Created by yuhua on 2021/2/6.
//

import UIKit

class EICellContentView: UIView {
    
    let title = UILabel()
    let l1 = UILabel()
    let l2 = UILabel()
    let l3 = UILabel()

    init(frame: CGRect, titleStr: String) {
        super.init(frame: frame)
        
        [title, l1, l2, l3].forEach {
            $0.text = "3.5"
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = UIColor(red: 0x33/0xff, green: 0x33/0xff, blue: 0x33/0xff, alpha: 1)
            $0.textAlignment = .center
            addSubview($0)
        }
        title.text = titleStr
        title.textColor = UIColor(red: 0x99/0xff, green: 0x99/0xff, blue: 0x99/0xff, alpha: 1)
        l3.mas_makeConstraints {
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.right.equalTo()(self)
            $0?.width.equalTo()(EICell.customWidth)
        }
        l2.mas_makeConstraints {
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.right.equalTo()(l3.mas_left)
            $0?.width.equalTo()(EICell.customWidth)
        }
        l1.mas_makeConstraints {
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.right.equalTo()(l2.mas_left)
            $0?.width.equalTo()(EICell.customWidth)
        }
        title.mas_makeConstraints {
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.right.equalTo()(l1.mas_left)
            $0?.width.equalTo()(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
