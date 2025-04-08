//
//  CommonAlertVC.swift
//  WeMinder
//
//  Created by Krishna on 21/05/19.
//  Copyright © 2019 Krishna All rights reserved.
//

import UIKit
import MBProgressHUD

var gIsPlaying: Bool = false
var gIsRefreshed: Bool = false

class CommonAlertVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonStop: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var heightViewContainer: NSLayoutConstraint!

    var videoURL = ""
    var selDevice: DmrDeviceInfo?
    var hud: MBProgressHUD?

    var arrayAction: [[String: () -> Void]]?
    var okButtonAct: (() ->())?

    var isContactNumberHidden: Bool = true

    enum WiFiIPVersion {
        case ipv4
        case ipv6
    }

    //监听事件
    let myCallback: dpsCtrlCallBack = { (action, numArg, Argname1, Argvalue1, Argname2, Argvalue2, Argname3, Argvalue3, Argname4, Argvalue4) in
        // 实现您的回调逻辑
        switch action {
        //设备状态变化
        case DMC_ACTION_DMRDEVICE_UPDATE:
            if let ov1 = Argvalue1 , let ov2 = Argvalue2,let on3 = Argvalue3 {
                let uuid = String(cString: ov1)
                let name = String(cString: ov2)

                print("发现设备 ： uuid -> \(uuid) , name -> \(name)")
                let state = String(cString :on3)
                if state == "1" {
                    //发现上线设备
                    SDKit.addNewDevice(udn: uuid, name: name)
                    Logger.shared.log(String(format: "彈窗-偵測到新設備"))
                }else{
                    // 移除离线设备
                    SDKit.removeOffDevice(udn: uuid)
                    Logger.shared.log(String(format: "彈窗-移除離線設備"))
                }
                SDKit.shared.post(event: "deveice_update", data: "")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DEVICEUPDATED"), object: nil)
                Logger.shared.log("彈窗-發佈DEVICEUPDATED廣播通知")
            }

        case DMC_EVENT_RECEIVED_UPDATE:
            if let ov1 = Argvalue1 ,let name = Argname2, let nval = Argvalue2 {
                let uuid = String(cString: ov1)
                /*
                 key 为 TransportState
                 value 为"PLAYING"播放中，"PAUSED_PLAYBACK"暂停，” STOPED”停止，“NO_MEDIA_PRESEN”当前无媒体播放
                 key 为 CurrentTrackDuration
                 value 为 当前播放视频的总时长
                 */
                let key = String(cString: name)
                let value = String(cString: nval)
                Logger.shared.log("彈窗-收到設備更新訊息-DMC_EVENT_RECEIVED_UPDATE")
                //print("状态 ： uuid -> \(uuid) , \(key) -> \(value)")
            }
        default:
            break
        }
        return 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 設定 UITableView
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        Logger.shared.log("彈窗-viewDidLoad")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Logger.shared.log("彈窗-viewWillAppear")

        NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(refreshTableView),
                    name: NSNotification.Name("DEVICEUPDATED"),
                    object: nil
        )

        viewContainer.layer.cornerRadius = 20.0
        viewContainer.layer.masksToBounds = true
        buttonPlay.addCornerRadiusWithShadow(color: .lightGray, borderColor: .clear, cornerRadius: 20)
        buttonStop.addCornerRadiusWithShadow(color: .lightGray, borderColor: .clear, cornerRadius: 20)
        setBtnStatus(isEnable: false, backgroudColor: .lightGray)

        if arrayAction == nil {

        } else {
            var count = 0
            for dic in arrayAction! {
                let allKeys = Array(dic.keys)
                let buttonTitle: String = allKeys[0].uppercased()
                if count == 0 {
                    buttonPlay.setTitle(buttonTitle, for: .normal)
                } else if count == 1 {
                    buttonStop.setTitle(buttonTitle, for: .normal)
                }
                count += 1
            }
        }
        myTableView.backgroundColor = UIColor.white
        self.refresh()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        Logger.shared.log("彈窗-viewWillDisappear")
    }

    func setBtnStatus(isEnable: Bool, backgroudColor: UIColor)  {
        buttonPlay.isEnabled = isEnable
        buttonStop.isEnabled = isEnable
        buttonPlay.backgroundColor = backgroudColor
        buttonStop.backgroundColor = backgroudColor
    }

    @objc func refreshTableView() {
        if SDKit.getAllDmrDevices().count > 0 {
            Logger.shared.log(String(format: "彈窗-有新裝置，數量%d", SDKit.getAllDmrDevices().count))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.myTableView.reloadData()
                let indexPath = IndexPath(row: 0, section: 0)
                self.myTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                self.setBtnStatus(isEnable: true, backgroudColor: UIColor(red: 39/255.0, green: 197/255.0, blue: 195/255.0, alpha: 1.0))
            }
            // self.setBtnStatus(isEnable: true, backgroudColor: UIColor(red: 39/255.0, green: 197/255.0, blue: 195/255.0, alpha: 1.0))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GETNEWDEVICE"), object:
                                                // ary
                                                SDKit.getAllDmrDevices()

            )
            Logger.shared.log("彈窗-收到DEVICEUPDATED廣播通知，再發送GETNEWDEVICE廣播通知底層頁面,傳送所有裝置")
        } else {
            Logger.shared.log("彈窗-收到DEVICEUPDATED廣播通知，並無偵測到任何裝置")
        }
    }

    @IBAction func playButtonAction(sender: UIButton) {
        self.play()
    }
    
    @IBAction func pauseButtonAction(sender: UIButton) {
        self.pause()
    }

    @IBAction func stopButtonAction(sender: UIButton) {
        self.cancelButtonAction(sender: UIButton())
    }

    @IBAction func cancelButtonAction(sender: UIButton) {
        self.dismiss(animated: true) {
            self.view.removeFromSuperview()
            self.close()
            MYOUCtrlPointExit();
        }
        Logger.shared.log("彈窗-取消彈窗顯示")
    }
}

extension CommonAlertVC {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Logger.shared.log(String(format: "彈窗-tableView numberOfRowsInSection=%ld", SDKit.getAllDmrDevices().count))
        return SDKit.getAllDmrDevices().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // cell.textLabel?.text = String(format: "%d", indexPath.row);
        let devices = SDKit.getAllDmrDevices()
        cell.textLabel?.text = devices[indexPath.row].name + "(" + devices[indexPath.row].udn + ")";

        cell.selectionStyle = .default
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .white

        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(red: 39/255.0, green: 197/255.0, blue: 195/255.0, alpha: 1.0)
        cell.selectedBackgroundView = selectedView

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let devices = SDKit.getAllDmrDevices()
        if devices.count > 0 {
            selDevice = devices[indexPath.row]
            self.setBtnStatus(isEnable: true, backgroudColor: UIColor(red: 39/255.0, green: 197/255.0, blue: 195/255.0, alpha: 1.0))
            Logger.shared.log(String(format: "彈窗-didSelectRowAt"))
            Logger.shared.log(String(format: "彈窗-設定按鈕顏色為藍色"))
            Logger.shared.log(String(format: "彈窗-selDevice"))
        }
    }
}

extension CommonAlertVC {
    func refresh() {
        self.close()
        MYOUCtrlPointExit();
//        if gIsRefreshed {
//            self.refreshTableView()
//            Logger.shared.log("彈窗-已經偵測過設備,直接執行refreshTableView，顯示設備")
//            return
//        }
        //AppId
        let cAppId = "65b05e7b5a00479fa2ccab2f800e6d0f".utf8CString
        //Secret
        let cSecret = "801c700dae2d43df".utf8CString
        // not used
        let cNotUse = "123".utf8CString
        // 乙太網路
        let en = "en0".utf8CString
        //本机ip
        let ip = (self.getWiFiIPAddress(version: .ipv4) ?? "127.0.0.1").utf8CString

        SDKit.removeAllDevice()
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.hud?.label.text = "启动中..."
        hud?.mode = .text

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            cAppId.withUnsafeBufferPointer { appID in
                let appIDPtr = appID.baseAddress
                cSecret.withUnsafeBufferPointer { secret in
                    let secretPtr = secret.baseAddress
                    cNotUse.withUnsafeBufferPointer { notUse in
                        let notUsePtr = notUse.baseAddress
                        en.withUnsafeBufferPointer { cEn in
                            let cEnPtr = cEn.baseAddress
                            ip.withUnsafeBufferPointer { cIp in
                                let cIpPtr = cIp.baseAddress
                                //注册平台信息
                                MYOUCtrlSetInfo(UnsafeMutablePointer(mutating: appIDPtr), UnsafeMutablePointer( mutating:  secretPtr), UnsafeMutablePointer(mutating:  notUsePtr));

                                //注册回调函数
                                dpsCtrlSetActionCallBack(self!.myCallback, nil);

                                //启动服务
                                let rc =  MYOUCtrlPointStart(UnsafeMutablePointer(mutating: cEnPtr), UnsafeMutablePointer(mutating: cIpPtr), 0, nil, 0);

                                print("[Adam] 海豚星空投屏启动\(rc == TV_SUCCESS ? "成功" : "失败")。")

                                if rc == TV_SUCCESS {
                                    Logger.shared.log("彈窗-SDK連結成功")
                                } else {
                                    Logger.shared.log("彈窗-SDK連結失敗")
                                }

                                let alert = UIAlertController(title: "提示", message: rc == TV_SUCCESS ? "海豚星空投屏启动成功" : "海豚星空投屏启动失败", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
                                    if rc == TV_SUCCESS {
                                        // gIsRefreshed = true
                                        // self?.navigationItem.rightBarButtonItem?.isEnabled = false
                                        let hud = MBProgressHUD.showAdded(to: self!.view, animated: true)
                                        hud.label.text = "侦测设备中..."
                                        Logger.shared.log("彈窗-偵測設備中...")
                                        hud.mode = .text
                                        // self?.refreshTableView()
                                        // 3 秒後自動隱藏
                                        // SDKit.addNewDevice(udn: "123", name: "test")
                                        // SDKit.addNewDevice(udn: "1234", name: "test２")

                                        // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DEVICEUPDATED"), object: nil)

                                        hud.hide(animated: true, afterDelay: 8)
                                    } else {
                                    }
                                })
                                self!.present(alert, animated: true, completion: nil)
                                self!.hud?.hide(animated: true)
                            }
                        }
                    }
                }
            }
        }
    }

    func play(){
        let videoUrl = self.videoURL
        let uriMetaData = "object.item.videoItem"

        if let selDevice = self.selDevice, !selDevice.udn.isEmpty, gIsPlaying == false {
            dpsCtrlPointSetAVTransportURI(TV_SERVICE_AVTRANSPORT,
                                          selDevice.udn,
                                          0,
                                          videoUrl,
                                          uriMetaData)
            gIsPlaying = true
            Logger.shared.log("彈窗-呼叫dpsCtrlPointSetAVTransportURI-開始播放")
        }
    }

    func pause(){
        if let selDevice = self.selDevice, !selDevice.udn.isEmpty {
            dpsCtrlPointPause(TV_SERVICE_AVTRANSPORT,
                              selDevice.udn,
                              0)
            Logger.shared.log("彈窗-呼叫dpsCtrlPointPause-暫停播放")
        }
    }

    func close(){
        if let selDevice = self.selDevice, !selDevice.udn.isEmpty, gIsPlaying == true {
            dpsCtrlPointStop(TV_SERVICE_AVTRANSPORT,
                             selDevice.udn,
                             0)
            gIsPlaying = false
            Logger.shared.log("彈窗-呼叫dpsCtrlPointStop-停止播放")
        }
    }

    func getWiFiIPAddress(version: WiFiIPVersion) -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?

        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family

            // 根據版本檢查
            let isValidFamily: Bool
            switch version {
            case .ipv4:
                isValidFamily = addrFamily == UInt8(AF_INET)
            case .ipv6:
                isValidFamily = addrFamily == UInt8(AF_INET6)
            }

            if isValidFamily {
                let name = String(cString: interface.ifa_name)
                if name == "en0" { // WiFi 接口
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                    break
                }
            }
        }

        freeifaddrs(ifaddr)
        Logger.shared.log(String(format: "彈窗-ip地址:%@", address ?? "N/A"))
        return address
    }
}

class Logger {
    static let shared = Logger()
    private var logFileURL: URL?

    private init() {
        let fileManager = FileManager.default
        if let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            logFileURL = docsDir.appendingPathComponent("app_log.txt") // 設定 Log 檔案名稱
        }
    }

    func log(_ message: String) {
        guard let logFileURL = logFileURL else { return }

        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        let logMessage = "[\(timestamp)] \(message)\n"

        if let data = logMessage.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: logFileURL.path) {
                if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            } else {
                try? data.write(to: logFileURL, options: .atomic)
            }
        }
    }

    func getLogFileURL() -> URL? {
        return logFileURL
    }
}
