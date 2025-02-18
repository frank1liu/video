//
//  SNShoppingVC.swift
//  SportNews
//
//  Created by yuhua on 2021/5/12.
//

import UIKit

class SNShoppingVC: QMUICommonViewController {
    
    let categoryView = JXCategoryTitleView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    var containerView: JXCategoryListContainerView!
    let titles = ["全部", "篮球周边", "足球周边", "话费"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "兑换商城"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "我的订单", style: .done, target: self, action: #selector(jumpOrder))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_返回"), style: .done, target: self, action: #selector(back))
        navigationController?.navigationBar.tintColor = .black
        edgesForExtendedLayout = [.left, .right, .bottom]
        view.backgroundColor = .white

        categoryView.delegate = self
        categoryView.backgroundColor = ColorF7F7F7
        categoryView.titles = titles
        categoryView.titleSelectedColor = Color27C5C3
        categoryView.isTitleColorGradientEnabled = true
        let indicator = JXCategoryIndicatorLineView()
        indicator.indicatorColor = Color27C5C3
        indicator.indicatorWidth = JXCategoryViewAutomaticDimension
        categoryView.indicators = [indicator]
        view.addSubview(categoryView)
        
        containerView = JXCategoryListContainerView(type: .scrollView, delegate: self)
        view.addSubview(containerView)
        containerView.mas_makeConstraints {
            $0?.left.equalTo()(view)
            $0?.right.equalTo()(view)
            $0?.bottom.equalTo()(view)
            $0?.top.equalTo()(categoryView.mas_bottom)
        }
        categoryView.listContainer = containerView
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }

    @objc func jumpOrder() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit {
        print("销毁了:\(type(of: self))")
    }
}


extension SNShoppingVC: JXCategoryViewDelegate, JXCategoryListContainerViewDelegate {
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return titles.count
    }
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        let vc = SNShoppingListVC()
        vc.itemSelected = { [weak self] viewType in
            let vc = SNShoppingDetailVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        vc.viewType = SNShoppingListVC.ViewType.init(rawValue: index)
        return vc
    }
}
