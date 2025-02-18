//
//  DNSManager.swift
//  IMYuanChat
//
//  Created by DS on 2024/11/21.
//  Copyright © 2024 
//  . All rights reserved.
//

import Foundation
import Reachability

@objc class DNSManager: NSObject {
    @objc static let shared = DNSManager()

    private var resolver: DNSResolver

    private var isResolving = false

    // test domain
    // @"test.kzb001.net";
    // @objc let domains = ["test.kzb001.net"]
    @objc let domains = ["u17elapi.top",
                         "2mntaapi.top",
                         "hkabaapi.top",
                         "2o6qgapi.top",
                         "kikh0api.top",
                         "u17elapi.xyz",
                         "2mntaapi.xyz",
                         "hkabaapi.xyz",
                         "2o6qgapi.xyz",
                         "kikh0api.xyz",
                         "u17elapi.icu",
                         "2mntaapi.icu",
                         "hkabaapi.icu",
                         "2o6qgapi.icu",
                         "kikh0api.icu",
                         "u17elapi.cyou",
                         "2mntaapi.cyou",
                         "hkabaapi.cyou",
                         "2o6qgapi.cyou",
                         "kikh0api.cyou"]

    /// 新增域名解析快取
    private var cachedIP: [String: (address: String, expiration: Date)] = [:]
    private var reachability: Reachability?
    private var netTimer: Timer?

    private override init() {
        self.resolver = DNSResolver.share()
        super.init()
        self.configure(accountId: "278050",
                       accessKeyId: "278050_29206697160285184",
                       accessKeySecret: "44cdd0f4f59f4640b78cc99567ce5559")
        self.observeNetworkChanges()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// 配置解析權限（如果需要阿里雲控制台生成的 `accountId` 和密鑰）
    private func configure(accountId: String, accessKeyId: String, accessKeySecret: String) {
        self.resolver.setAccountId(accountId, andAccessKeyId: accessKeyId, andAccesskeySecret: accessKeySecret)
    }

    /// 預解析一組域名（可以在應用啟動時調用以加速後續操作）
    @objc func preloadDomains(_ domains: [String], completion: (() -> Void)? = nil) {
        self.resolver.preloadDomains(domains) {
            completion?()
        }
    }

    /// 緩存一組域名
    @objc func keepAliveDomains(_ domains: [String]) {
        self.resolver.setKeepAliveDomains(domains)
    }

    /// 從快取獲取 IP，如果快取無效則即時解析
    @objc func getIPForDomain(_ domain: String, completion: @escaping (String?, Error?) -> Void) {
        // 檢查本地快取，若快取存在且未過期，直接返回
        if let cached = self.cachedIP[domain], cached.expiration > Date() {
            completion(cached.address, nil)
            return
        }

        // 如果快取不存在或已過期，進行即時解析
        self.resolveFastestIP(domain: domain) { [weak self] ip, error in
            guard let strongSelf = self else { return }
            if let ip = ip {
                // 將解析結果加入快取，有效期設置為 10 分鐘
                strongSelf.cachedIP[domain] = (address: ip, expiration: Date().addingTimeInterval(600))
            }
            completion(ip, error)
        }
    }

    /// 執行單個域名解析，返回隨機 IP 地址（最快的 IP）
    @objc func resolveFastestIP(domain: String, completion: @escaping (String?, Error?) -> Void) {
        guard !self.isResolving else {
            return
        }

        // 檢查快取，避免重複解析
        if let cached = self.cachedIP[domain], cached.expiration > Date() {
            completion(cached.address, nil)
            return
        }

        self.isResolving = true
        self.resolver.getRandomIpv4Data(withDomain: domain) { [weak self] fastestIP in
            guard let strongSelf = self else { return }
            strongSelf.isResolving = false
            if let fastestIP = fastestIP {
                // 快取解析結果，有效期設置為 10 分鐘
                strongSelf.cachedIP[domain] = (address: fastestIP, expiration: Date().addingTimeInterval(600))
                completion(fastestIP, nil)
            } else {
                let error = NSError(domain: "DNSManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No fastest IP found for domain: \(domain)"])
                completion(nil, error)
            }
        }
    }

    /// 監聽網路變更，自動重新解析域名
    private func observeNetworkChanges() {
        self.reachability = Reachability.forInternetConnection()
        guard let reachability = self.reachability else { return }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: NSNotification.Name(NSNotification.Name.reachabilityChanged.rawValue),
            object: nil
        )

        // 啟動網路監聽
        reachability.startNotifier()

        // 初次檢查網路狀態
        self.checkNetworkStatus()
    }

    /// 停止監聽網路變更
    private func stopObservingNetworkChanges() {
        self.reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(NSNotification.Name.reachabilityChanged.rawValue), object: nil)
        self.reachability = nil
    }

    /// 網路狀態變化通知處理
    @objc private func networkStatusChanged(_ notification: Notification) {
        self.checkNetworkStatus()
    }

    /// 檢查當前網路狀態並處理
    private func checkNetworkStatus() {
        guard let reachability = self.reachability else { return }

        let networkStatus = reachability.currentReachabilityStatus()

        switch networkStatus {
        case .NotReachable:
            self.handleNoNetwork()
        case .ReachableViaWiFi, .ReachableViaWWAN:
            self.handleNetworkAvailable()
        @unknown default:
            break
        }
    }

    /// 當網路不可用時的處理邏輯
    private func handleNoNetwork() {
        self.startRetryingNetworkCheck()
    }

    /// 當網路可用時的處理邏輯
    private func handleNetworkAvailable() {
        NotificationCenter.default.post(name: Notification.Name("NetworkAvailable"), object: nil)
        self.stopRetryingNetworkCheck()
        self.networkChanged()
    }

    /// 開始重試網路檢查
    private func startRetryingNetworkCheck() {
        guard self.netTimer == nil else { return }


        self.netTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.checkNetworkStatus()
        }
    }

    /// 停止重試網路檢查
    private func stopRetryingNetworkCheck() {
        self.netTimer?.invalidate()
        self.netTimer = nil
    }

    /// 網路變更時重新解析域名
    private func networkChanged() {
    }

    /// 重新嘗試解析
    @objc func retryNetWork() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.networkChanged()
        }
    }

    /// 清除緩存（可以用於清理特定域名或全部清理）
    @objc func clearCache(for domains: [String]? = nil) {
        self.resolver.clearHostCache(domains ?? [])
        self.cachedIP.removeAll()
    }
}

