//
//  AICell.swift
//  SportNews
//
//  Created by yuhua on 2021/2/6.
//

import UIKit

class AICell: UITableViewCell {
    
    let company = Company()
    let start = StartView()
    let now = NowView()
    let background = UIView()
    
    var model: SNExponentContent? {
        didSet {
            let lefts = model?.initial.components(separatedBy: ",")
            let rights = model?.realtime.components(separatedBy: ",")
            company.title.text = model?.company_name
            if (lefts?.count ?? 0) > 2 {
                start.l1.text = lefts?[0]
                start.l2.text = lefts?[1]
                start.l3.text = lefts?[2]
            }
            if (rights?.count ?? 0) > 2 {
                now.l1.text = rights?[0]
                now.l2.text = rights?[1]
                now.l3.text = rights?[2]
                checkLabelColor(label: now.l1, start: lefts?[0] ?? "0", now: rights?[0] ?? "0")
                checkLabelColor(label: now.l2, start: lefts?[1] ?? "0", now: rights?[1] ?? "0")
                checkLabelColor(label: now.l3, start: lefts?[2] ?? "0", now: rights?[2] ?? "0")
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(company)
        company.mas_makeConstraints {
            $0?.left.equalTo()(contentView)
            $0?.top.equalTo()(contentView)
            $0?.bottom.equalTo()(contentView)
        }
        background.backgroundColor = .init(red: 0xf4/0xff, green: 0xf4/0xff, blue: 0xf4/0xff, alpha: 1)
        background.layer.cornerRadius = 5
        contentView.addSubview(background)
        contentView.addSubview(start)
        contentView.addSubview(now)
        background.mas_makeConstraints {
            $0?.left.equalTo()(company.mas_right)?.offset()(5)
            $0?.top.equalTo()(contentView)?.offset()(5)
            $0?.bottom.equalTo()(contentView)?.offset()(-5)
            $0?.right.equalTo()(contentView)?.offset()(-5)
            
        }
        start.mas_makeConstraints {
            $0?.left.equalTo()(company.mas_right)
            $0?.top.equalTo()(contentView)
            $0?.bottom.equalTo()(contentView)
            $0?.width.equalTo()(company)?.multipliedBy()(2)
        }
        now.mas_makeConstraints {
            $0?.right.equalTo()(contentView)
            $0?.top.equalTo()(contentView)
            $0?.bottom.equalTo()(contentView)
            $0?.left.equalTo()(start.mas_right)
            $0?.width.equalTo()(start)
        }
    }
    
    func checkLabelColor(label: UILabel, start: String, now: String) {
        if let start = Double(start), let now = Double(now) {
            if now > start {
                label.textColor = ColorDA4155
            } else if now < start {
                label.textColor = Color73D9D8
            } else {
                label.textColor = Color333333
            }
        } else {
            label.textColor = Color333333
        }
    }
    
    func changeCellBackground(change: Bool) {
        background.isHidden = !change
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
