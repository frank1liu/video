//
//  CompanyListVC.swift
//  SportNews
//
//  Created by yuhua on 2021/3/9.
//

import UIKit

class CompanyListVC: QMUICommonTableViewController {
    
    var contents: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var current = 0
    var changeCompany: ((Int)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "CompanyCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
        let content = contents[indexPath.row]
        cell.title.text = content
        cell.change(change: current == indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        current = indexPath.row
        changeCompany?(current)
        tableView.reloadData()
    }
}

class CompanyCell: QMUITableViewCell {
    
    let title = QMUILabel.buildPingLabel(text: "",
                                         textColor: Color666666,
                                         font: .systemFont(ofSize: 12),
                                         alignment: .center)
    let back = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(back)
        back.layer.cornerRadius = 15
        back.backgroundColor = ColorDA4155
        back.mas_makeConstraints {
            $0?.left.equalTo()(contentView)?.offset()(10)
            $0?.top.equalTo()(contentView)?.offset()(5)
            $0?.right.equalTo()(contentView)?.offset()(-10)
            $0?.bottom.equalTo()(contentView)?.offset()(-5)
        }
        
        contentView.addSubview(title)
        title.mas_makeConstraints {
            $0?.edges.equalTo()(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func change(change: Bool) {
        back.isHidden = !change
        title.textColor = change ? .white : Color666666
    }
}
