//
//  LivePlayerPingVC.swift
//  SportNews
//
//  Created by yuhua on 2021/2/27.
//

import UIKit

var gVC:LivePlayerPingVC? = nil

class LivePlayerPingVC: QMUICommonViewController {
    
    let tableView = QMUITableView()
    @objc var parentVC:LiveDetailController? = nil;

    @objc var videoUrl = ""
    var allDevices: [DmrDeviceInfo] = []

    var devices = [CLUPnPDevice]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "投电视"
        view.backgroundColor = ColorF5F5F5
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "刷新"), style: .done, target: self, action: #selector(refresh))

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = ColorF5F5F5
        view.addSubview(tableView)
        tableView.mas_makeConstraints {
            $0?.left.equalTo()(self.view)
            $0?.right.equalTo()(self.view)
            $0?.top.equalTo()(self.view)
            $0?.bottom.equalTo()(self.view)
        }
        gVC = self
        Logger.shared.log(String(format: "app version: %@",Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "無法取得版本號"))
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            self.refresh()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: "leftArrow"), style: .plain, target: self, action: #selector(customBack))
        self.navigationItem.leftBarButtonItem = backButton

        NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(self.getDeviceInfo(nofi:)),
                    name: NSNotification.Name("GETNEWDEVICE"),
                    object: nil
        )
        if let bundleID = Bundle.main.bundleIdentifier, bundleID != "com.SportLives.Ball.ccc.adam" {
            let alert = UIAlertController(title: "提示", message: "请在下载页选择企业版方可投屏！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            self.present(alert, animated: true, completion: nil)
        }
        Logger.shared.log("首頁-viewWillAppear-進入投屏")
    }

    @objc func customBack() {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Logger.shared.log("首頁-viewDidAppear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        navigationController?.setNavigationBarHidden(true, animated: true)
        Logger.shared.log("首頁-viewWillDisappear")
        print("海豚星空投屏 销毁")
        if gIsPlaying {
            Logger.shared.log("首頁-viewWillDisappear-正在播放，停止播放並離開")
            self.close();
        }
        gVC = nil;
        gIsRefreshed = false
        parentVC?.isClickPop = false
        #if targetEnvironment(simulator)

        #else
        MYOUCtrlPointExit();
        #endif
        Logger.shared.log("首頁-呼叫MYOUCtrlPointExit-停止投屏SDK")
    }
    
    @objc public func refresh() {
        let actionPlay : [String: () -> Void] = [ "播放" : { (

        ) }]
        let actionStop : [String: () -> Void] = [ "退出投屏" : { (

        ) }]

        let arrayActions = [actionPlay, actionStop]

        UIViewController.showCustomAlertWith(VC: self,
                                             message: "",
                                             descMsg: "",
                                             itemimage: nil,
                                             videoURL: self.videoUrl,
                                             actions: arrayActions)
        Logger.shared.log("首頁-點擊首頁右上角refresh按鈕，開啟投屏操作視窗")
    }

    func close(){
        if self.allDevices.count > 0, !self.allDevices[0].udn.isEmpty {
            #if targetEnvironment(simulator)

            #else
            dpsCtrlPointStop(TV_SERVICE_AVTRANSPORT,
                             self.allDevices[0].udn,
                             0)
            #endif
            gIsPlaying = false
            Logger.shared.log(String(format: "首頁-關閉投屏-dpsCtrlPointStop"))
        }
    }

    @objc func getDeviceInfo(nofi: Notification) {
        if let deviceInfo = nofi.object as? [DmrDeviceInfo] {
            self.allDevices = deviceInfo
            if self.allDevices.count > 0 {
                Logger.shared.log(String(format: "首頁-getDeviceInfo"))
            }
            tableView.reloadData()
        }
    }
}

extension LivePlayerPingVC: QMUITableViewDelegate, QMUITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = DeviceCell(style: .default, reuseIdentifier: "Cell1")
            cell.videoUrl = videoUrl
            cell.setModels(devices: allDevices)
            return cell
        } else {
            return UseCell(style: .default, reuseIdentifier: "Cell2")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if devices.isEmpty {
                return 40 + 50 + 20
            } else {
                return 40 + 50 * CGFloat(devices.count) + 20
            }
        } else {
            return 718 + 20
        }
    }
}


class DeviceCell: QMUITableViewCell {
    
    var stack: UIStackView?
    var devices: [DmrDeviceInfo] = []
    var videoUrl = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 10
        contentView.layer.borderColor = ColorF5F5F5.cgColor
        contentView.layer.cornerRadius = 13
        
        let title = QMUILabel.buildPingLabel(text: "选择投屏设备", textColor: Color333333, font: .systemFont(ofSize: 11), alignment: .center)
        contentView.addSubview(title)
        title.mas_makeConstraints {
            $0?.left.equalTo()(contentView)
            $0?.top.equalTo()(contentView)?.offset()(10)
            $0?.right.equalTo()(contentView)
            $0?.height.equalTo()(39.5)
        }
        
        let view = UIView()
        view.backgroundColor = Color979797
        contentView.addSubview(view)
        view.mas_makeConstraints {
            $0?.left.equalTo()(contentView)?.offset()(27)
            $0?.top.equalTo()(title.mas_bottom)
            $0?.right.equalTo()(contentView)?.offset()(-27)
            $0?.height.equalTo()(0.5)
        }
    }
    
    func setModels(devices: [DmrDeviceInfo]) {
        self.devices = devices
        if devices.count == 0 {
            Logger.shared.log("首頁-cell裝置數為0")
            let label = QMUILabel.buildPingLabel(text: "未发现可用设备，请点击右上角重新搜索！", textColor: Color333333, font: .systemFont(ofSize: 12), alignment: .center)
            contentView.addSubview(label)
            label.mas_makeConstraints {
                $0?.left.equalTo()(contentView)
                $0?.bottom.equalTo()(contentView)?.offset()(-10)
                $0?.right.equalTo()(contentView)
                $0?.top.equalTo()(contentView)?.offset()(50)
            }
        } else {
            let button = QMUIButton.buildPingButton(text: devices[0].name + "(" + devices[0].udn + ")")
            Logger.shared.log(String(format: "首頁-設定cell按鈕文字"))
            button.addTarget(self, action: #selector(choice(btn:)), for: .touchUpInside)
            button.isUserInteractionEnabled = true
            stack = UIStackView()
            stack?.addArrangedSubview(button)
            stack!.axis = .vertical
            stack!.distribution = .fillEqually
            contentView.addSubview(stack!)
            stack!.mas_makeConstraints {
                $0?.left.equalTo()(contentView)
                $0?.bottom.equalTo()(contentView)?.offset()(-10)
                $0?.right.equalTo()(contentView)
                $0?.top.equalTo()(contentView)?.offset()(50)
            }
        }
    }
    
    @objc func choice(btn: QMUIButton) {
        stack?.arrangedSubviews.forEach {
            ($0 as! QMUIButton).isSelected = false
        }
        Logger.shared.log(String(format: "首頁-點擊choice按鈕, 按鈕文字"))
        btn.isSelected = true
        gVC?.refresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UseCell: QMUITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 10
        contentView.layer.borderColor = ColorF5F5F5.cgColor
        contentView.layer.cornerRadius = 13
        
        let t1 = QMUILabel.buildPingLabel(text: "如何投屏到电视？", textColor: Color333333, font: .systemFont(ofSize: 19, weight: UIFont.Weight.init(2)), alignment: .center)
        let t2 = QMUILabel.buildPingLabel(text: "1、打开智能电视/盒子，确认您的电视/盒子与助手连接在同一个Wi-Fi。", textColor: Color333333, font: .systemFont(ofSize: 14, weight: UIFont.Weight.init(2)), alignment: .left)
        t2.numberOfLines = 0
        let image1 = UIImageView(image: UIImage(named: "组合"))
        image1.contentMode = .center
        let t3 = QMUILabel.buildPingLabel(text: "2、点击快直播手机播放器右上角按钮，即可投屏到电视。", textColor: Color333333, font: .systemFont(ofSize: 15, weight: UIFont.Weight.init(2)), alignment: .left)
        t3.numberOfLines = 0
        let t4 = QMUILabel.buildPingLabel(text: "如检测不到就可能是设备不支持，可到页面上方重新搜索设备。", textColor: Color979797, font: .systemFont(ofSize: 13), alignment: .left)
        t4.numberOfLines = 0
        let image2 = UIImageView(image: UIImage(named: "img1"))
        image2.contentMode = .center
        let t5 = QMUILabel.buildPingLabel(text: "为什么还是投屏失败？", textColor: Color333333, font: .systemFont(ofSize: 19, weight: UIFont.Weight.init(2)), alignment: .center)
        let t6 = QMUILabel.buildPingLabel(text: "1、电视/盒子与手机没有连接在同一Wi-Fi，或手机可能连接了4G网络。\n\n2、电视/盒子机型老旧，不支持DLNA或AirPlay投射协议。", textColor: Color979797, font: .systemFont(ofSize: 13), alignment: .left)
        t6.numberOfLines = 0
        
        let stack = UIStackView(arrangedSubviews: [t1, t2, image1, t3, t4, image2, t5, t6])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        contentView.addSubview(stack)
        stack.mas_makeConstraints {
            $0?.left.equalTo()(contentView)?.offset()(28)
            $0?.right.equalTo()(contentView)?.offset()(-28)
            $0?.top.equalTo()(contentView)?.offset()(28)
            $0?.bottom.equalTo()(contentView)?.offset()(-28)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

