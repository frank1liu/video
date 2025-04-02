//
//  AnnouncementViewController.swift
//  HereHearV2
//
//  Created by Frank Liu on 2020/3/31.
//  Copyright © 2020 Frank Liu. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProjectorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    @objc var videoURL = ""
    var isPlaying: Bool = false
    var selDevice: DmrDeviceInfo?
    var hud: MBProgressHUD?

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
                }else{
                    // 移除离线设备
                    SDKit.removeOffDevice(udn: uuid)
                }
                SDKit.shared.post(event: "deveice_update", data: "")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DEVICEUPDATED"), object: nil)
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

                //print("状态 ： uuid -> \(uuid) , \(key) -> \(value)")
            }
        default:
            break
        }
        return 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "投电视"
        self.view.backgroundColor = ColorF5F5F5
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "刷新"), style: .done, target: self, action: #selector(refresh))
        // 設定 UITableView
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(refreshTableView),
                    name: NSNotification.Name("DEVICEUPDATED"),
                    object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self)
        print("海豚星空投屏 销毁")
        if isPlaying {
            self.close(sender: UIButton());
        }
        MYOUCtrlPointExit();
    }

    @objc func refreshTableView() {
        self.myTableView.reloadData()
    }
}

extension ProjectorViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SDKit.getAllDmrDevices().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // cell.textLabel?.text = data[indexPath.row]
        // cell.textLabel?.text = String(format: "%d", indexPath.row);
        let devices = SDKit.getAllDmrDevices()
        cell.textLabel?.text = devices[indexPath.row].name + "(" + devices[indexPath.row].udn + ")";
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let devices = SDKit.getAllDmrDevices()
        selDevice = devices[indexPath.row]
    }}

extension ProjectorViewController {
    @objc func refresh() {
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

                                print("[Adam] 海豚星空投屏 SDK 启动\(rc == TV_SUCCESS ? "成功" : "失败")。")

                                let alert = UIAlertController(title: "提示", message: rc == TV_SUCCESS ? "海豚星空投屏 SDK 启动成功" : "海豚星空投屏 SDK 启动失败", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "確定", style: .default) { _ in
                                    if rc == TV_SUCCESS {
                                        self?.navigationItem.rightBarButtonItem?.isEnabled = false
                                        let hud = MBProgressHUD.showAdded(to: self!.view, animated: true)
                                        hud.label.text = "侦测设备中..."
                                        hud.mode = .text

                                        // 1.5 秒後自動隱藏
                                        hud.hide(animated: true, afterDelay: 3)
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

    @IBAction func play(sender: UIButton){
        let videoUrl = self.videoURL
        let uriMetaData = "object.item.videoItem"

        if let selDevice = self.selDevice, !selDevice.udn.isEmpty {
            dpsCtrlPointSetAVTransportURI(TV_SERVICE_AVTRANSPORT,
                                          selDevice.udn,
                                          0,
                                          videoUrl,
                                          uriMetaData)
            self.isPlaying = true
        }
    }

    @IBAction func pause(sender: UIButton){
        if let selDevice = self.selDevice, !selDevice.udn.isEmpty {
            dpsCtrlPointPause(TV_SERVICE_AVTRANSPORT,
                              selDevice.udn,
                              0)
        }
    }

    @IBAction func close(sender: UIButton){
        if let selDevice = self.selDevice, !selDevice.udn.isEmpty {
            dpsCtrlPointStop(TV_SERVICE_AVTRANSPORT,
                             selDevice.udn,
                             0)
            self.isPlaying = false
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
        return address
    }
}
