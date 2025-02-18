//
//  NowView.swift
//  SportNews
//
//  Created by yuhua on 2021/2/6.
//

import UIKit

class NowView: UIView {

    var l1: UILabel!
    var l2: UILabel!
    var l3: UILabel!
    var image = UIImageView(image: UIImage(named: "enter"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        l1 = buildLabel(title: "0.82")
        l2 = buildLabel(title: "-0/0.5")
        l3 = buildLabel(title: "1.00")
        image.contentMode = .center
        addSubview(l1)
        addSubview(l2)
        addSubview(l3)
        addSubview(image)
        image.mas_makeConstraints {
            $0?.right.equalTo()(self)?.offset()(-7)
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.width.equalTo()(7)
        }
        l1.mas_makeConstraints {
            $0?.left.equalTo()(self)
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
        }
        l2.mas_makeConstraints {
            $0?.left.equalTo()(l1.mas_right)
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.width.equalTo()(l1)
        }
        l3.mas_makeConstraints {
            $0?.left.equalTo()(l2.mas_right)
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.right.equalTo()(image.mas_left)
            $0?.right.equalTo()(self)
            $0?.width.equalTo()(l2)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = Color333333
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }
}
