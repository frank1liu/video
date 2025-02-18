//
//  SNShoppingDetailVC.swift
//  SportNews
//
//  Created by yuhua on 2021/5/13.
//

import UIKit

class SNShoppingDetailVC: QMUICommonTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "兑换详情"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_返回"), style: .done, target: self, action: #selector(back))
        navigationController?.navigationBar.tintColor = .black
        edgesForExtendedLayout = [.left, .right, .bottom]
        view.backgroundColor = ColorF5F5F5
        
        tableView.register(SNShoppingDetailHeaderCell.self, forCellReuseIdentifier: "ShoppingHeader")
        tableView.register(SNShoppingDetailPriceCell.self, forCellReuseIdentifier: "ShoppingPrice")
        tableView.register(SNShoppingDetailDetailCell.self, forCellReuseIdentifier: "ShoppingDetail")
        tableView.separatorStyle = .none
        tableView.backgroundColor = ColorF5F5F5
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("销毁了:\(type(of: self))")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            /// 顶部
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingHeader", for: indexPath) as! SNShoppingDetailHeaderCell
            return cell
        } else if indexPath.row == 1 {
            /// 价格
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingPrice", for: indexPath) as! SNShoppingDetailPriceCell
            return cell
        } else {
            /// 详情
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingDetail", for: indexPath) as! SNShoppingDetailDetailCell
            return cell
        }
    }
}
