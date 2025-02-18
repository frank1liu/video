//
//  EuroIndexView.swift
//  SportNews
//
//  Created by yuhua on 2021/2/6.
//

import UIKit

class EuroIndexView: UIView {
    
    let tableView = UITableView()
    var showType = 0 {
        didSet {
            tableView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 13
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 25, height: 80))
        let one = EIHeaderOne()
        one.choice = { [weak self] index in
            self?.showType = index
        }
        let two = EIHeaderTwo()
        header.addSubview(one)
        header.addSubview(two)
        one.mas_makeConstraints {
            $0?.left.equalTo()(header)
            $0?.right.equalTo()(header)
            $0?.top.equalTo()(header)
        }
        two.mas_makeConstraints {
            $0?.left.equalTo()(header)
            $0?.right.equalTo()(header)
            $0?.bottom.equalTo()(header)
            $0?.top.equalTo()(one.mas_bottom)
            $0?.height.equalTo()(one)
        }
        
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(EICell.self, forCellReuseIdentifier: "EICell")
        tableView.tableHeaderView = header
        tableView.mas_makeConstraints {
            $0?.left.equalTo()(self)
            $0?.right.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.top.equalTo()(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EuroIndexView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EICell", for: indexPath) as! EICell
        cell.changeBackground(change: indexPath.row % 2 == 0)
        cell.showContent(type: showType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showType != 0 {
            return 25.5
        }
        return 51
    }
}
