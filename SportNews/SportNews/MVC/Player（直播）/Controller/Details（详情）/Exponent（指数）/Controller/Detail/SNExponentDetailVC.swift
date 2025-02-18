//
//  SNExponentDetailVC.swift
//  SportNews
//
//  Created by yuhua on 2021/3/9.
//

import UIKit

class SNExponentDetailVC: QMUICommonViewController {

    /// 类型，1足球，2篮球
    @objc var type: Int = 1
    /// 对应详情类型
    @objc var detailType: Int = 0
    /// 公司id
    @objc var comID: Int = 0
    /// 比赛id
    @objc var vsID: Int = 0
    
    /// 公司列表，上个界面传入
    @objc var companyList: [[String: Any]] = []
    
    /// 公司
    let listLeft = CompanyListVC()
    
    /// 指数详情
    let listRight = CompanyExponentDetailVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = ColorDA4155
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorDA4155]
        edgesForExtendedLayout = [.left, .right, .bottom]
        
        view.backgroundColor = .white
        
        var list: [String] = []
        if type == 1 {
            if detailType == 1 {
                title = "全场让球指数变化"
                list = ["公司", "主队", "走势", "客队", "时间"]
            } else if detailType == 2 {
                title = "全场胜平负指数变化"
                list = ["公司", "主胜", "平局", "客胜", "返还率", "时间"]
            } else if detailType == 3 {
                title = "全场总进球指数变化"
                list = ["公司", "多", "走势", "少", "时间"]
            } else if detailType == 4 {
                title = "全场角球指数变化"
                list = ["公司", "多", "走势", "少", "时间"]
            }
        } else if type == 2 {
            if detailType == 1 {
                title = "全场让分指数变化"
                list = ["公司", "客队", "走势", "主队", "时间"]
            } else if detailType == 2 {
                title = "全场胜负指数变化"
                list = ["公司", "客胜", "主队", "返还率", "时间"]
            } else if detailType == 3 {
                title = "全场总分指数变化"
                list = ["公司", "多", "走势", "少", "时间"]
            }
        }
        
        let top = ExponentDetailTitle(titles: list)
        view.addSubview(top)
        top.mas_makeConstraints {
            $0?.left.equalTo()(view)
            $0?.right.equalTo()(view)
            $0?.top.equalTo()(view)
            $0?.height.equalTo()(30)
        }
        
        view.addSubview(listLeft.view)
        listLeft.current = companyList.firstIndex { ($0["company_id"] as? String) == "\(comID)" } ?? 0
        listLeft.contents = companyList.map {
            return $0["company_name"] as! String
        }
        listLeft.changeCompany = { [weak self] index in
            if let company = self?.companyList[index] {
                self?.comID = Int((company["company_id"] as? String) ?? "0") ?? 0
                self?.request()
            }
        }
        listLeft.view.mas_makeConstraints {
            $0?.left.equalTo()(view)
            $0?.bottom.equalTo()(view.mas_safeAreaLayoutGuideBottom)
            $0?.top.equalTo()(top.mas_bottom)
            $0?.width.equalTo()(UIScreen.main.bounds.width/CGFloat(list.count+2)*2)
        }
        
        listRight.type = type
        listRight.etype = detailType
        listRight.refresh = { [weak self] in
            self?.requestNoHud()
        }
        view.addSubview(listRight.view)
        listRight.view.mas_makeConstraints {
            $0?.right.equalTo()(view)
            $0?.bottom.equalTo()(view.mas_safeAreaLayoutGuideBottom)
            $0?.top.equalTo()(top.mas_bottom)
            $0?.left.equalTo()(listLeft.view.mas_right)?.offset()
        }
        
        let line = UIView()
        line.backgroundColor = ColorF7F7F7
        view.addSubview(line)
        line.mas_makeConstraints {
            $0?.bottom.equalTo()(view)
            $0?.top.equalTo()(top.mas_bottom)
            $0?.left.equalTo()(listLeft.view.mas_right)
            $0?.width.equalTo()(0.5)
        }
        
        request()
    }
    
    func request() {
        
        KYRemindView.show()
        KYApiHttpTool.get(ExponentDetailAPI,
                          withParams: [
                            "type": type,
                            "mid": vsID,
                            "companyid": comID,
                            "etype": detailType
                          ]) { [self] response in
            if let data = response["data"] as? [String: Any],
               let list = data["historyList"] as? [[Any]] {
                self.listRight.content = list
            }
            KYRemindView.dismiss()
        } failure: { error in
            KYRemindView.show(withStatus: "数据请求失败！")
        }
    }
    
    func requestNoHud() {
        KYApiHttpTool.get(ExponentDetailAPI,
                          withParams: [
                            "type": type,
                            "mid": vsID,
                            "companyid": comID,
                            "etype": detailType
                          ]) { [self] response in
            if let data = response["data"] as? [String: Any],
               let list = data["historyList"] as? [[Any]] {
                self.listRight.content = list
            }
            self.listRight.tableView.mj_header?.endRefreshing()
        } failure: { error in
            KYRemindView.show(withStatus: "数据请求失败！")
            self.listRight.tableView.mj_header?.endRefreshing()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
