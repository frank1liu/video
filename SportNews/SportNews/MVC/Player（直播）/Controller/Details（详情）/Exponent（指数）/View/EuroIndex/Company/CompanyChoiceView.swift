//
//  CompanyChoiceView.swift
//  SportNews
//
//  Created by yuhua on 2021/2/7.
//

import UIKit

class CompanyChoiceView: UIView {
    
    let tableView = QMUITableView()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        let title = UILabel(frame: CGRect(x: 14.5, y: 9.5, width: 80, height: 20))
        title.text = "类型选择"
        title.textColor = Color666666
        title.font = .systemFont(ofSize: 14)
        addSubview(title)
        
        let close = UIImageView(image: UIImage(named: "关闭"))
        close.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        close.addGestureRecognizer(tap)
        close.contentMode = .center
        close.frame = CGRect(x: frame.size.width-11-15, y: 15, width: 11, height: 11)
        addSubview(close)
        
        let bottom = CompanyChoiceBottomView(frame: CGRect(x: 0, y: frame.height - 50.5, width: frame.width, height: 50.5))
        addSubview(bottom)
        
        let type = CompanyTypeChoiceView(frame: CGRect(x: 0, y: 40, width: frame.width, height: 30.5))
        addSubview(type)
        
        let az = CompanyTypeAZView(frame: CGRect(x: 0, y: 78.5, width: frame.width, height: 30.5))
        addSubview(az)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = ColorFBFBFB
        tableView.register(CCCell.self, forCellReuseIdentifier: "CCCell")
        tableView.frame = CGRect(x: 0, y: 124, width: frame.width, height: frame.height - 124 - 50.5)
        addSubview(tableView)
    }
    
    @objc func closeView() {
        UIHelper.shared.hideModalView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CompanyChoiceView: QMUITableViewDataSource, QMUITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CCCell", for: indexPath) as! CCCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

class CCCell: QMUITableViewCell {
    
    let name = QMUILabel(frame: CGRect(x: 15, y: 0, width: 100, height: 40))
    let choice = QMUIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = ColorFBFBFB
        
        name.text = "测试"
        name.textColor = Color666666
        name.font = .systemFont(ofSize: 12)
        contentView.addSubview(name)
        
        choice.frame = CGRect(x: UIScreen.main.bounds.width - 40 - 50, y: 0, width: 40, height: 40)
        choice.setImage(UIImage(named: "未选备份"), for: .normal)
        choice.setImage(UIImage(named: "选中"), for: .selected)
        contentView.addSubview(choice)
        choice.addTarget(self, action: #selector(choice(btn:)), for: .touchUpInside)
    }
    
    @objc func choice(btn: QMUIButton) {
        btn.isSelected = !btn.isSelected
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
