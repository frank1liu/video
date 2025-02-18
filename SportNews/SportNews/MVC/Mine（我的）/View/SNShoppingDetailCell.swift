//
//  SNShoppingDetailCell.swift
//  SportNews
//
//  Created by yuhua on 2021/5/13.
//

import UIKit

/// 头部详情
class SNShoppingDetailHeaderCell: QMUITableViewCell {
    
    let imageV = UIImageView()
    let back = UIView()
    let title = QMUILabel.buildPingLabel(text: "标题", textColor: Color333333, font: .systemFont(ofSize: 18, weight: .bold), alignment: .left)
    let have = QMUILabel.buildPingLabel(text: "已兑100件        剩余100件", textColor: Color979797, font: .systemFont(ofSize: 10), alignment: .right)
    let price = QMUILabel.buildPingLabel(text: "13000", textColor: Color4BCDCB, font: .systemFont(ofSize: 16, weight: .bold), alignment: .left)
    let priceImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = ColorF5F5F5
        imageV.image = UIImage(named: "编组 10")
        contentView.addSubview(imageV)
        imageV.mas_makeConstraints {
            $0?.top.equalTo()(contentView)
            $0?.left.equalTo()(contentView)
            $0?.right.equalTo()(contentView)
            $0?.bottom.equalTo()(contentView)?.offset()(-60)
            $0?.height.equalTo()(contentView.mas_width)
        }
        back.backgroundColor = .white
        back.layer.cornerRadius = 10
        back.layer.shadowColor = UIColor.black.cgColor
        back.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.addSubview(back)
        back.mas_makeConstraints {
            $0?.left.equalTo()(contentView)?.offset()(12)
            $0?.right.equalTo()(contentView)?.offset()(-12)
            $0?.bottom.equalTo()(contentView)?.offset()(-6)
            $0?.height.equalTo()(80)
        }
        back.addSubview(have)
        back.addSubview(price)
        back.addSubview(priceImage)
        back.addSubview(title)
        have.mas_makeConstraints {
            $0?.left.equalTo()(back)
            $0?.right.equalTo()(back)?.offset()(-12)
            $0?.bottom.equalTo()(back)?.offset()(-12)
        }
        priceImage.image = UIImage(named: "音浪特小")
        priceImage.mas_makeConstraints {
            $0?.left.equalTo()(back)?.offset()(12)
            $0?.bottom.equalTo()(have)
            $0?.height.equalTo()(20)
            $0?.width.equalTo()(20)
        }
        price.mas_makeConstraints {
            $0?.top.equalTo()(priceImage)
            $0?.bottom.equalTo()(priceImage)
            $0?.left.equalTo()(priceImage.mas_right)?.offset()(5)
            $0?.right.equalTo()(back)
        }
        title.mas_makeConstraints {
            $0?.top.equalTo()(back)
            $0?.left.equalTo()(back)?.offset()(12)
            $0?.right.equalTo()(back)?.offset()(-12)
            $0?.bottom.equalTo()(priceImage.mas_top)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 价格详情
class SNShoppingDetailPriceCell: QMUITableViewCell {
    
    let back = UIView()
    let title1 = QMUILabel.buildPingLabel(text: "产品简介", textColor: Color333333, font: .systemFont(ofSize: 14, weight: .bold), alignment: .left)
    let detail1 = QMUILabel.buildPingLabel(text: "这是一个非常好的产品。", textColor: Color666666, font: .systemFont(ofSize: 13), alignment: .left)
    let title2 = QMUILabel.buildPingLabel(text: "兑换说明", textColor: Color333333, font: .systemFont(ofSize: 14, weight: .bold), alignment: .left)
    let detail2 = QMUILabel.buildPingLabel(text: "仅需要999就可以兑换哟。", textColor: Color666666, font: .systemFont(ofSize: 13), alignment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = ColorF5F5F5
        back.backgroundColor = .white
        back.layer.cornerRadius = 10
        back.layer.shadowColor = UIColor.black.cgColor
        back.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.addSubview(back)
        back.mas_makeConstraints {
            $0?.top.equalTo()(contentView)?.offset()(6)
            $0?.left.equalTo()(contentView)?.offset()(12)
            $0?.right.equalTo()(contentView)?.offset()(-12)
            $0?.bottom.equalTo()(contentView)?.offset()(-6)
        }
        back.addSubview(title1)
        back.addSubview(detail1)
        back.addSubview(title2)
        back.addSubview(detail2)
        title1.mas_makeConstraints {
            $0?.top.equalTo()(back)?.offset()(12)
            $0?.left.equalTo()(back)?.offset()(12)
            $0?.right.equalTo()(back)?.offset()(-12)
        }
        detail1.mas_makeConstraints {
            $0?.top.equalTo()(title1.mas_bottom)?.offset()(12)
            $0?.left.equalTo()(title1)
            $0?.right.equalTo()(title1)
        }
        title2.mas_makeConstraints {
            $0?.top.equalTo()(detail1.mas_bottom)?.offset()(12)
            $0?.left.equalTo()(title1)
            $0?.right.equalTo()(title1)
        }
        detail2.mas_makeConstraints {
            $0?.top.equalTo()(title2.mas_bottom)?.offset()(12)
            $0?.left.equalTo()(title1)
            $0?.right.equalTo()(title1)
            $0?.bottom.equalTo()(back)?.offset()(-12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 商品详情
class SNShoppingDetailDetailCell: QMUITableViewCell {
    
    let back = UIView()
    let title = QMUILabel.buildPingLabel(text: "商品详情", textColor: Color333333, font: .systemFont(ofSize: 14, weight: .bold), alignment: .left)
    let imageV = UIImageView()
    let buy = QMUIButton.buildPingButton(text: "2888音浪兑换")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = ColorF5F5F5
        buy.setTitleColor(.white, for: .normal)
        buy.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        buy.layer.cornerRadius = 25
        buy.layer.masksToBounds = true
        buy.addGradientLayer(colors: [Color19ABF5, Color68FF87], frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-40, height: 50))
        contentView.addSubview(buy)
        buy.mas_makeConstraints {
            $0?.left.equalTo()(contentView)?.offset()(20)
            $0?.right.equalTo()(contentView)?.offset()(-20)
            $0?.height.equalTo()(50)
            $0?.bottom.equalTo()(contentView)?.offset()(-20)
        }
        back.backgroundColor = .white
        back.layer.cornerRadius = 10
        back.layer.shadowColor = UIColor.black.cgColor
        back.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.addSubview(back)
        back.mas_makeConstraints {
            $0?.top.equalTo()(contentView)?.offset()(6)
            $0?.left.equalTo()(contentView)?.offset()(12)
            $0?.right.equalTo()(contentView)?.offset()(-12)
            $0?.bottom.equalTo()(buy.mas_top)?.offset()(-20)
        }
        imageV.image = UIImage(named: "编组 9")
        back.addSubview(title)
        back.addSubview(imageV)
        title.mas_makeConstraints {
            $0?.top.equalTo()(back)?.offset()(12)
            $0?.left.equalTo()(back)?.offset()(12)
            $0?.right.equalTo()(back)?.offset()(-12)
        }
        imageV.mas_makeConstraints {
            $0?.top.equalTo()(title.mas_bottom)?.offset()(12)
            $0?.left.equalTo()(title)
            $0?.right.equalTo()(title)
            $0?.height.equalTo()(imageV.mas_width)
            $0?.bottom.equalTo()(back)?.offset()(-12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

