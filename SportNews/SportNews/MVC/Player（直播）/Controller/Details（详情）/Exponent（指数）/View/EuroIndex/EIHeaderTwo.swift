//
//  EIHeaderTwo.swift
//  SportNews
//
//  Created by yuhua on 2021/2/6.
//

import UIKit

class EIHeaderTwo: UIView {

    let color = UIColor(red: 0x99/0xff, green: 0x99/0xff, blue: 0x99/0xff, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let l1 = UILabel()
        l1.font = .systemFont(ofSize: 12)
        l1.textColor = color
        l1.text = "公司"
        addSubview(l1)
        l1.mas_makeConstraints {
            $0?.left.equalTo()(self)?.offset()(15)
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.width.equalTo()(40)
        }
        
        let l2 = EIHeaderTitle(frame: .zero, title: "主胜")
        let l3 = EIHeaderTitle(frame: .zero, title: "平局")
        let l4 = EIHeaderTitle(frame: .zero, title: "客胜")
        addSubview(l2)
        addSubview(l3)
        addSubview(l4)
        l4.mas_makeConstraints {
            $0?.width.equalTo()(EICell.customWidth)
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.right.equalTo()(self)?.offset()(-10)
        }
        l3.mas_makeConstraints {
            $0?.width.equalTo()(l4)
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.right.equalTo()(l4.mas_left)
        }
        l2.mas_makeConstraints {
            $0?.width.equalTo()(l3)
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.right.equalTo()(l3.mas_left)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class EIHeaderTitle: UIView {
    
    let title = UILabel()
    let image = UIImageView(image: UIImage(named: "排序2"))
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        
        self.title.text = title
        self.title.textColor = UIColor(red: 0x99/0xff, green: 0x99/0xff, blue: 0x99/0xff, alpha: 1)
        self.title.font = .systemFont(ofSize: 12)
        self.title.textAlignment = .center
        addSubview(self.title)
        addSubview(image)
        image.contentMode = .center
        self.title.mas_makeConstraints {
            $0?.center.equalTo()(self)
            $0?.height.equalTo()(24)
            $0?.width.equalTo()(30)
        }
        image.mas_makeConstraints {
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.left.equalTo()(self.title.mas_right)
            $0?.width.equalTo()(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
