//
//  SNShoppingListCell.swift
//  SportNews
//
//  Created by yuhua on 2021/5/12.
//

import UIKit

class SNShoppingListCell: UICollectionViewCell {
    
    let image = UIImageView()
    let title = QMUILabel.buildPingLabel(text: "名字", textColor: Color333333, font: .systemFont(ofSize: 14, weight: .bold), alignment: .left)
    let price = QMUILabel.buildPingLabel(text: "13000", textColor: Color4BCDCB, font: .systemFont(ofSize: 16, weight: .bold), alignment: .left)
    let priceImage = UIImageView()
    let sales = QMUILabel.buildPingLabel(text: "已兑100件", textColor: Color979797, font: .systemFont(ofSize: 10), alignment: .left)
    let spare = QMUILabel.buildPingLabel(text: "剩余100件", textColor: Color979797, font: .systemFont(ofSize: 10), alignment: .right)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 10
        
        [image, title, price, priceImage, sales, spare].forEach {
            contentView.addSubview($0)
        }
        
        image.mas_makeConstraints {
            $0?.left.equalTo()(contentView)
            $0?.top.equalTo()(contentView)
            $0?.right.equalTo()(contentView)
            $0?.height.equalTo()(contentView.mas_width)
        }
        
        sales.mas_makeConstraints {
            $0?.left.equalTo()(image)?.offset()(12)
            $0?.bottom.equalTo()(contentView)?.offset()(-8)
            $0?.right.equalTo()(image)
            $0?.height.equalTo()(20)
        }
        
        spare.mas_makeConstraints {
            $0?.right.equalTo()(image)?.offset()(-12)
            $0?.bottom.equalTo()(sales)
            $0?.left.equalTo()(image)
            $0?.height.equalTo()(sales)
        }
        
        priceImage.image = UIImage(named: "音浪特小")
        priceImage.mas_makeConstraints {
            $0?.left.equalTo()(sales)
            $0?.bottom.equalTo()(sales.mas_top)?.offset()(-4)
            $0?.height.equalTo()(priceImage.mas_width)
            $0?.height.equalTo()(20)
        }
        
        price.mas_makeConstraints {
            $0?.top.equalTo()(priceImage)
            $0?.bottom.equalTo()(priceImage)
            $0?.left.equalTo()(priceImage.mas_right)?.offset()(5)
            $0?.right.equalTo()(sales)
        }
        
        title.mas_makeConstraints {
            $0?.left.equalTo()(image)?.offset()(12)
            $0?.top.equalTo()(image.mas_bottom)?.offset()(8)
            $0?.right.equalTo()(image)?.offset()(-12)
            $0?.bottom.equalTo()(priceImage.mas_top)?.offset()(-4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 改变item内容
    /// - Parameters:
    ///   - title: 标题
    ///   - price: 价格
    ///   - sale: 已兑
    ///   - spare: 剩余
    ///   - image: 图片
    func changeItem(title: String, price: Int, sale: Int, spare: Int, image: UIImage) {
        self.title.text = title
        self.price.text = "\(price)"
        self.sales.text = "已兑\(sale)件"
        self.spare.text = "剩余\(spare)件"
        self.image.image = image
    }
}
