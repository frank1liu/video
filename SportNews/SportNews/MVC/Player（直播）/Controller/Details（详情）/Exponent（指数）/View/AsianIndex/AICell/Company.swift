//
//  Company.swift
//  SportNews
//
//  Created by yuhua on 2021/2/6.
//

import UIKit

class Company: UIView {
    
    let image = UIImageView()
    let title = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .init(red: 0xe9/0xff, green: 0xf6/0xff, blue: 0xf6/0xff, alpha: 1)
        
//        addSubview(image)
        addSubview(title)
        
        title.text = "测试"
        image.image = UIImage(named: "展开")
        
        image.contentMode = .center
        
        title.textColor = .init(red: 0x66/0xff, green: 0x66/0xff, blue: 0x66/0xff, alpha: 1)
        title.font = .systemFont(ofSize: 12)
        title.textAlignment = .center
        title.numberOfLines = 2
        
//        image.mas_makeConstraints {
//            $0?.left.equalTo()(self)?.offset()(4)
//            $0?.top.equalTo()(self)
//            $0?.bottom.equalTo()(self)
//            $0?.width.equalTo()(6.5)
//        }
        title.mas_makeConstraints {
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.right.equalTo()(self)
            $0?.left.equalTo()(self)
//            $0?.left.equalTo()(image.mas_right)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
