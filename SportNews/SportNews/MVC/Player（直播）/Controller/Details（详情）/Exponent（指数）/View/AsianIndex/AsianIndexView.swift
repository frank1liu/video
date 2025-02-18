//
//  AsianIndexView.swift
//  SportNews
//
//  Created by yuhua on 2021/2/6.
//

import UIKit

class AsianIndexView: UIView {
    
    let tableView = UITableView()
    @objc var models: [SNExponentContent]? {
        didSet {
            tableView.reloadData()
        }
    }
    let emptyView = UIImageView(image: UIImage(named: "暂无比赛"))
    let emptyText = QMUILabel()
    
    @objc var jump: ((Int)->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 13
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
        tableView.tableHeaderView = ExponentAsianIndexTitle(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 25, height: 43))

        tableView.mj_header = MJRefreshNormalHeader();
        tableView.mj_header?.setRefreshingTarget(self, refreshingAction: #selector(refreshData))

        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(AICell.self, forCellReuseIdentifier: "AICell")
        tableView.mas_makeConstraints {
            $0?.left.equalTo()(self)
            $0?.right.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.top.equalTo()(self)
        }
        
        emptyText.font = UIFont(name: "PingFangSC-Regular", size: 14)
        emptyText.textColor = UIColor.qmui_color(withRGBAString: "102,102,102")
        emptyText.textAlignment = .center
        emptyText.text = "暂无数据"
        addSubview(emptyView)
        addSubview(emptyText)
        emptyView.mas_makeConstraints {
            $0?.size.equalTo()(CGSize(width: 201, height: 134.5))
            $0?.centerX.equalTo()(self)
            $0?.top.equalTo()(self)?.offset()(100)
        }
        emptyText.mas_makeConstraints {
            $0?.left.equalTo()(self)
            $0?.right.equalTo()(self)
            $0?.top.equalTo()(emptyView.mas_bottom)
            $0?.height.mas_equalTo()(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showEmpty() {
        if let models = self.models, !models.isEmpty {
            emptyView.isHidden = true
            emptyText.isHidden = true
        } else {
            emptyText.isHidden = false
            emptyView.isHidden = false
        }
    }

    @objc func refreshData() {
        tableView.reloadData()
        tableView.mj_header?.endRefreshing()
    }
}


extension AsianIndexView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showEmpty()
        return models?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AICell", for: indexPath) as! AICell
        cell.changeCellBackground(change: indexPath.row % 2 == 1)
        cell.model = models?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = models?[indexPath.row].company_id {
            jump?(id)
        }
    }
}
