//
//  EICell.swift
//  SportNews
//
//  Created by yuhua on 2021/2/6.
//

import UIKit

class EICell: UITableViewCell {
    
    static let customWidth: CGFloat = 60
    
    let company = UILabel()
    let background = UIView()
    let start = EICellContentView(frame: .zero, titleStr: "初")
    let now = EICellContentView(frame: .zero, titleStr: "即")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        background.layer.cornerRadius = 5
        contentView.addSubview(background)
        background.mas_makeConstraints {
            $0?.left.equalTo()(contentView)?.offset()(10)
            $0?.right.equalTo()(contentView)?.offset()(-10)
            $0?.top.equalTo()(contentView)
            $0?.bottom.equalTo()(contentView)
        }
        
        company.textColor = UIColor(red: 0x33/0xff, green: 0x33/0xff, blue: 0x33/0xff, alpha: 1)
        company.font = .systemFont(ofSize: 11)
        company.text = "测试"
        background.addSubview(company)
        company.mas_makeConstraints {
            $0?.left.equalTo()(background)?.offset()(5)
            $0?.top.equalTo()(background)
            $0?.bottom.equalTo()(background)
            $0?.right.equalTo()(background)?.offset()(-EICell.customWidth * 3 - 20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeBackground(change: Bool) {
        background.backgroundColor = change ? .init(red: 0xf4/0xff, green: 0xf4/0xff, blue: 0xf4/0xff, alpha: 1) : .white
    }
    
    func showContent(type: Int) {
        start.removeFromSuperview()
        now.removeFromSuperview()
        if type == 0 {
            background.addSubview(start)
            background.addSubview(now)
            start.mas_makeConstraints {
                $0?.width.equalTo()(EICell.customWidth * 3 + 20)
                $0?.right.equalTo()(background)
                $0?.top.equalTo()(background)
            }
            now.mas_makeConstraints {
                $0?.width.equalTo()(EICell.customWidth * 3 + 20)
                $0?.right.equalTo()(background)
                $0?.bottom.equalTo()(background)
                $0?.top.equalTo()(start.mas_bottom)
                $0?.height.equalTo()(start)
            }
        } else if type == 1 {
            background.addSubview(start)
            start.mas_makeConstraints {
                $0?.width.equalTo()(EICell.customWidth * 3 + 20)
                $0?.right.equalTo()(background)
                $0?.top.equalTo()(background)
                $0?.bottom.equalTo()(background)
            }
        } else if type == 2 {
            background.addSubview(now)
            now.mas_makeConstraints {
                $0?.width.equalTo()(EICell.customWidth * 3 + 20)
                $0?.right.equalTo()(background)
                $0?.top.equalTo()(background)
                $0?.bottom.equalTo()(background)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
