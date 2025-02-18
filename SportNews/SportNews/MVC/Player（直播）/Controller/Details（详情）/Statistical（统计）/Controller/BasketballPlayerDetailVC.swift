//
//  BasketballPlayerDetailVC.swift
//  SportNews
//
//  Created by yuhua on 2021/4/19.
//

import UIKit

class BasketballPlayerDetailVC: QMUICommonViewController {
    
    /// 保持vc
    static var handle: BasketballPlayerDetailVC?
    /// 背景遮罩view
    let backView = UIView(frame: UIScreen.main.bounds)
    
    /// 滑动返回按钮
    let back = UIView()
    
    /// 数据模型
    var playerModel: SNStatisticalPlayerModel? {
        didSet {
            if let count = playerModel?.player.count,
               count >= 7,
               let info = playerModel?.player[6] as? String {
                self.content.reloadPlayerInfo(info: info)
            }
            self.content.reloadChangci(number: playerModel?.changci ?? 0)
        }
    }
    
    /// 数据模型
    var model: SNStatisticalHeaderMemberModel? {
        didSet {
            self.content.name.text = model?.name_zh;
            self.content.number.text = model?.qiuyi == nil ? "" : (model!.qiuyi + "号")
            self.content.imageView.sd_setImage(with: URL(string: model?.logo ?? ""), placeholderImage: UIImage(named: "默认头像"))
        }
    }
    
    /// 内容
    fileprivate let content = ContentView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 400)
        view.layer.cornerRadius = 13
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        scroll(top: true)
         
        let btn = UIButton.init()
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        backView.insertSubview(btn, at: 0)
        btn.mas_makeConstraints {
            $0?.edges.equalTo()(backView)
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panMove(pan:)))
        pan.minimumNumberOfTouches = 1
        content.addGestureRecognizer(pan)
        content.qq.addTarget(self, action: #selector(shared), for: .touchUpInside)
        content.wx.addTarget(self, action: #selector(shared), for: .touchUpInside)
        content.pyq.addTarget(self, action: #selector(shared), for: .touchUpInside)
        content.save.addTarget(self, action: #selector(save), for: .touchUpInside)
        view.addSubview(content)
        content.mas_makeConstraints {
            $0?.left.equalTo()(view)
            $0?.bottom.equalTo()(view)
            $0?.right.equalTo()(view)
            $0?.top.equalTo()(view)
        }
        
        content.addSubview(back)
        back.layer.cornerRadius = 2
        back.backgroundColor = ColorD6D6D6
        back.mas_makeConstraints {
            $0?.centerX.equalTo()(content)
            $0?.top.equalTo()(content)?.offset()(12)
            $0?.size.equalTo()(CGSize(width: 30, height: 4))
        }
    }
    
    deinit {
        print("\(type(of: self))销毁了")
    }
    
    func scroll(top: Bool) {
        if top {
            UIView.animate(withDuration: 0.5) {
                self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-400, width: UIScreen.main.bounds.width, height: 400)
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 400)
                self.backView.alpha = 0
            } completion: { _ in
                self.dismissVC()
            }
        }
    }
    
    /// 拖拽
    @objc func panMove(pan: UIPanGestureRecognizer) {
        let y = pan.translation(in: backView).y
        if y >= 0 {
            view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 400 + y, width: UIScreen.main.bounds.width, height: 400)
        } else {
            view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 400, width: UIScreen.main.bounds.width, height: 400)
        }
        if pan.state == .ended {
            scroll(top: y < 100)
        }
    }
     
    @objc func clickBtn() {
        scroll(top: false)
    }
     
    /// 弹出
    @objc static func show(playerModel: SNStatisticalPlayerModel, model: SNStatisticalHeaderMemberModel) {
        let vc = BasketballPlayerDetailVC()
        vc.show()
        vc.playerModel = playerModel
        vc.model = model
    }
    
    /// 弹出
    func show() {
        BasketballPlayerDetailVC.handle = self
        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        backView.addSubview(view)
        let window = UIApplication.shared.delegate!.window!
        window?.addSubview(backView)
    }
    /// 外部手动消失
    @objc static func dismissVC() {
        BasketballPlayerDetailVC.handle?.dismissVC()
    }
    /// 消失
    @objc private func dismissVC() {
        backView.removeFromSuperview()
        BasketballPlayerDetailVC.handle = nil
    }
     
    
    /// 分享
    @objc func shared() {
        let param = ["pid": "4"]
        KYRemindView.show()
        KYApiHttpTool.get("sys/share/txt", withParams: param) { [weak self] response in
            let text = response["share_txt"] as? String
            let iamge = UIImage(named: "1024Logo.png")
            let urlStr = response["share_url"] as? String
            let url = URL(string: urlStr ?? "")
            let activity = CustomActivity(title: text ?? "", activityImage: iamge, url: url, activityType: "Custom")
            let activityVC = UIActivityViewController(activityItems: [text ?? "", iamge!, url!], applicationActivities: [activity!])
            self?.present(activityVC, animated: true)
        } failure: { _ in }
    }
    
    /// 保存
    @objc func save() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.shotScreen()
        }
    }
    
    //截屏
    func shotScreen() {
        let scale: CGFloat = UIScreen.main.scale   // 设置屏幕倍率可以保证截图的质量
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, true, scale)
        let window = UIApplication.shared.delegate!.window!
        window?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //保存相册
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            KYRemindView.show(withStatus: "保存失败")
        } else {
            KYRemindView.show(withStatus: "保存成功")
        }
        
    }
}


fileprivate class ContentView: UIView {
    
    let imageView = UIImageView()
    let name = QMUILabel.buildPingLabel(text: " ", textColor: .black, font: .systemFont(ofSize: 14, weight: .bold), alignment: .left)
    let number = QMUILabel.buildPingLabel(text: " ", textColor: Color979797, font: .systemFont(ofSize: 11), alignment: .left)
    let b1 = buildButton(title: "1")
    let b2 = buildButton(title: "2")
    let b3 = buildButton(title: "3")
    let b4 = buildButton(title: "4")
    let b5 = buildButton(title: "全场")
    /// 时间
    let l10 = QMUILabel.buildPingLabel(text: "-", textColor: Color666666, font: .systemFont(ofSize: 12, weight: .bold), alignment: .center)
    /// 得分
    let l11 = QMUILabel.buildPingLabel(text: "-", textColor: Color666666, font: .systemFont(ofSize: 12, weight: .bold), alignment: .center)
    /// 篮板
    let l12 = QMUILabel.buildPingLabel(text: "-", textColor: Color666666, font: .systemFont(ofSize: 12, weight: .bold), alignment: .center)
    /// 助攻
    let l13 = QMUILabel.buildPingLabel(text: "-", textColor: Color666666, font: .systemFont(ofSize: 12, weight: .bold), alignment: .center)
    /// 抢断
    let l14 = QMUILabel.buildPingLabel(text: "-", textColor: Color666666, font: .systemFont(ofSize: 12, weight: .bold), alignment: .center)
    /// 盖帽
    let l15 = QMUILabel.buildPingLabel(text: "-", textColor: Color666666, font: .systemFont(ofSize: 12, weight: .bold), alignment: .center)
    /// 投篮
    let l20 = QMUILabel.buildPingLabel(text: "-", textColor: Color666666, font: .systemFont(ofSize: 12, weight: .bold), alignment: .center)
    /// 命中率
    let l21 = QMUILabel.buildPingLabel(text: "-", textColor: Color666666, font: .systemFont(ofSize: 12, weight: .bold), alignment: .center)
    /// 两分球
    let l22 = QMUILabel.buildPingLabel(text: "-", textColor: Color666666, font: .systemFont(ofSize: 12, weight: .bold), alignment: .center)
    /// 三分球
    let l23 = QMUILabel.buildPingLabel(text: "-", textColor: Color666666, font: .systemFont(ofSize: 12, weight: .bold), alignment: .center)
    /// 罚球
    let l24 = QMUILabel.buildPingLabel(text: "-", textColor: Color666666, font: .systemFont(ofSize: 12, weight: .bold), alignment: .center)
    let qq = buildButton(title: "QQ好友", image: "QQ")
    let wx = buildButton(title: "微信好友", image: "微信")
    let pyq = buildButton(title: "朋友圈", image: "朋友圈")
    let save = buildButton(title: "保存图片", image: "保存图片")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [imageView, name, number, b1, b2, b3, b4, b5, l10, l11, l12, l13, l14, l15, l20, l21, l22, l23, l24].forEach {
            addSubview($0)
        }
        imageView.image = UIImage.init(named: "默认图片")
        imageView.contentMode = .scaleAspectFit
        imageView.mas_makeConstraints {
            $0?.left.equalTo()(self)?.offset()(15)
            $0?.top.equalTo()(self)?.offset()(24)
            $0?.size.equalTo()(CGSize(width: 40, height: 40))
        }
        name.mas_makeConstraints {
            $0?.top.equalTo()(imageView)?.offset()(3)
            $0?.left.equalTo()(imageView.mas_right)?.offset()(8)
            $0?.height.equalTo()(imageView)?.dividedBy()(2)
            $0?.right.equalTo()(self)
        }
        number.mas_makeConstraints {
            $0?.bottom.equalTo()(imageView)
            $0?.left.equalTo()(imageView.mas_right)?.offset()(8)
            $0?.height.equalTo()(imageView)?.dividedBy()(2)
            $0?.right.equalTo()(self)
        }
        var up: QMUIButton?
        [b1, b2, b3, b4, b5].forEach {
            $0.isUserInteractionEnabled = false
            if up == nil {
                $0.mas_remakeConstraints {
                    $0?.top.equalTo()(imageView.mas_bottom)?.offset()(23)
                    $0?.left.equalTo()(self)?.offset()(15)
                    $0?.height.equalTo()(26)
                }
            } else if $0 == b5 {
                $0.mas_makeConstraints {
                    $0?.top.equalTo()(up)
                    $0?.left.equalTo()(up?.mas_right)?.offset()(15)
                    $0?.right.equalTo()(self)?.offset()(-15)
                    $0?.height.equalTo()(up)
                    $0?.width.equalTo()(up)
                }
            } else {
                $0.mas_makeConstraints {
                    $0?.top.equalTo()(up)
                    $0?.left.equalTo()(up?.mas_right)?.offset()(15)
                    $0?.height.equalTo()(up)
                    $0?.width.equalTo()(up)
                }
            }
            up = $0
        }
        var upLabel: QMUILabel?
        [l10, l11, l12, l13, l14, l15].forEach {
            if $0 == l10 {
                $0.mas_remakeConstraints {
                    $0?.top.equalTo()(b1.mas_bottom)?.offset()(20)
                    $0?.left.equalTo()(self)
                    $0?.height.equalTo()(18)
                }
            } else if $0 == l15 {
                $0.mas_makeConstraints {
                    $0?.top.equalTo()(upLabel)
                    $0?.left.equalTo()(upLabel?.mas_right)
                    $0?.right.equalTo()(self)
                    $0?.height.equalTo()(upLabel)
                    $0?.width.equalTo()(upLabel)
                }
            } else {
                $0.mas_makeConstraints {
                    $0?.top.equalTo()(upLabel)
                    $0?.left.equalTo()(upLabel?.mas_right)
                    $0?.height.equalTo()(upLabel)
                    $0?.width.equalTo()(upLabel)
                }
            }
            upLabel = $0
        }
        ["时间", "得分", "篮板", "助攻", "抢断", "盖帽"].forEach {
            let lable = QMUILabel.buildPingLabel(text: $0, textColor: Color979797, font: .systemFont(ofSize: 12), alignment: .center)
            addSubview(lable)
            if $0 == "时间" {
                lable.mas_remakeConstraints {
                    $0?.top.equalTo()(l10.mas_bottom)?.offset()(3)
                    $0?.left.equalTo()(self)
                    $0?.height.equalTo()(18)
                }
            } else if $0 == "盖帽" {
                lable.mas_makeConstraints {
                    $0?.top.equalTo()(upLabel)
                    $0?.left.equalTo()(upLabel?.mas_right)
                    $0?.right.equalTo()(self)
                    $0?.height.equalTo()(upLabel)
                    $0?.width.equalTo()(upLabel)
                }
            } else {
                lable.mas_makeConstraints {
                    $0?.top.equalTo()(upLabel)
                    $0?.left.equalTo()(upLabel?.mas_right)
                    $0?.height.equalTo()(upLabel)
                    $0?.width.equalTo()(upLabel)
                }
            }
            upLabel = lable
        }
        let line = UIView()
        line.backgroundColor = Color979797
        addSubview(line)
        line.mas_makeConstraints {
            $0?.top.equalTo()(upLabel?.mas_bottom)?.offset()(15)
            $0?.left.equalTo()(self)?.offset()(15)
            $0?.right.equalTo()(self)?.offset()(-15)
            $0?.height.equalTo()(0.5)
        }
        [l20, l21, l22, l23, l24].forEach {
            if $0 == l20 {
                $0.mas_remakeConstraints {
                    $0?.top.equalTo()(line.mas_bottom)?.offset()(15)
                    $0?.left.equalTo()(self)
                    $0?.height.equalTo()(18)
                }
            } else if $0 == l24 {
                $0.mas_makeConstraints {
                    $0?.top.equalTo()(upLabel)
                    $0?.left.equalTo()(upLabel?.mas_right)
                    $0?.right.equalTo()(self)
                    $0?.height.equalTo()(upLabel)
                    $0?.width.equalTo()(upLabel)
                }
            } else {
                $0.mas_makeConstraints {
                    $0?.top.equalTo()(upLabel)
                    $0?.left.equalTo()(upLabel?.mas_right)
                    $0?.height.equalTo()(upLabel)
                    $0?.width.equalTo()(upLabel)
                }
            }
            upLabel = $0
        }
        ["投篮", "命中率", "两分球", "三分球", "罚球"].forEach {
            let lable = QMUILabel.buildPingLabel(text: $0, textColor: Color979797, font: .systemFont(ofSize: 12), alignment: .center)
            addSubview(lable)
            if $0 == "投篮" {
                lable.mas_remakeConstraints {
                    $0?.top.equalTo()(l20.mas_bottom)?.offset()(3)
                    $0?.left.equalTo()(self)
                    $0?.height.equalTo()(18)
                }
            } else if $0 == "罚球" {
                lable.mas_makeConstraints {
                    $0?.top.equalTo()(upLabel)
                    $0?.left.equalTo()(upLabel?.mas_right)
                    $0?.right.equalTo()(self)
                    $0?.height.equalTo()(upLabel)
                    $0?.width.equalTo()(upLabel)
                }
            } else {
                lable.mas_makeConstraints {
                    $0?.top.equalTo()(upLabel)
                    $0?.left.equalTo()(upLabel?.mas_right)
                    $0?.height.equalTo()(upLabel)
                    $0?.width.equalTo()(upLabel)
                }
            }
            upLabel = lable
        }
        let bottom = UIView()
        bottom.backgroundColor = ColorF7F7F7
        addSubview(bottom)
        bottom.mas_makeConstraints {
            $0?.left.equalTo()(self)
            $0?.right.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.top.equalTo()(upLabel?.mas_bottom)?.offset()(20)
        }
        let share = QMUILabel.buildPingLabel(text: "分享投篮分布点给好友", textColor: Color979797, font: .systemFont(ofSize: 12), alignment: .center)
        bottom.addSubview(share)
        share.mas_makeConstraints {
            $0?.left.equalTo()(self)
            $0?.right.equalTo()(self)
            $0?.top.equalTo()(bottom)?.offset()(15)
        }
        let space = (UIScreen.main.bounds.width - 65 * 4)/8
        addSubview(qq)
        qq.mas_makeConstraints {
            $0?.top.equalTo()(share.mas_bottom)?.offset()(10)
            $0?.width.equalTo()(65)
            $0?.height.equalTo()(65)
            $0?.left.equalTo()(bottom)?.offset()(space)
        }
        addSubview(wx)
        wx.mas_makeConstraints {
            $0?.top.equalTo()(qq)
            $0?.width.equalTo()(qq)
            $0?.height.equalTo()(qq)
            $0?.left.equalTo()(qq.mas_right)?.offset()(space*2)
        }
        addSubview(pyq)
        pyq.mas_makeConstraints {
            $0?.top.equalTo()(qq)
            $0?.width.equalTo()(qq)
            $0?.height.equalTo()(qq)
            $0?.left.equalTo()(wx.mas_right)?.offset()(space*2)
        }
        addSubview(save)
        save.mas_makeConstraints {
            $0?.top.equalTo()(qq)
            $0?.width.equalTo()(qq)
            $0?.height.equalTo()(qq)
            $0?.left.equalTo()(pyq.mas_right)?.offset()(space*2)
        }
    }
    
    func reloadPlayerInfo(info: String) {
        let arr = info.components(separatedBy: "^")
        if arr.count >= 17 {
            l10.text = arr[0].isEmpty ? "-" : arr[0]
            l11.text = arr[13].isEmpty ? "-" : arr[13]
            l12.text = arr[6].isEmpty ? "-" : arr[6]
            l13.text = arr[7].isEmpty ? "-" : arr[7]
            l14.text = arr[8].isEmpty ? "-" : arr[8]
            l15.text = arr[9].isEmpty ? "-" : arr[9]
            let tl = arr[1]
            let sf = arr[2]
            let tls = tl.components(separatedBy: "-").map { Double($0) ?? 0 }
            let sfs = sf.components(separatedBy: "-").map { Double($0) ?? 0 }
            let lfl = Int((tls.first ?? 0)-(sfs.first ?? 0))
            let lfr = Int((tls.last ?? 0)-(sfs.last ?? 0))
            l20.text = tl.isEmpty ? "-" : tl.replacingOccurrences(of: "-", with: "/")
            l21.text = String(format: "%0.1f%%", (tls.first ?? 0)/(tls.last ?? 0) * 100)
            l22.text = "\(lfl)/\(lfr)"
            l23.text = sf.isEmpty ? "-" : sf.replacingOccurrences(of: "-", with: "/")
            l24.text = arr[3].isEmpty ? "-" : arr[3].replacingOccurrences(of: "-", with: "/")
        }
    }
    
    func reloadChangci(number: Int) {
        if number >= 1 && number <= 5 {
            btnSlected(btn: [b1, b2, b3, b4, b5][number-1])
            btnHidden(number: number)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnSlected(btn: QMUIButton) {
        [b1, b2, b3, b4, b5].forEach {
            $0.isSelected = false
            $0.backgroundColor = .white
            $0.layer.borderWidth = 1 
        }
        btn.isSelected = true
        btn.backgroundColor = ColorECFBF9
        btn.layer.borderWidth = 0
    }
    
    @objc func btnHidden(number: Int) {
        let array = [b1, b2, b3, b4, b5]
        for i in 0..<array.count {
            let btn = array[i]
            btn.isHidden = false
            if i >= number {
                btn.isHidden = true
            }
        }
    }
    
    static func buildButton(title: String) -> QMUIButton {
        let btn = QMUIButton()
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(Color666666, for: .normal)
        btn.setTitleColor(Color27C5C3, for: .selected)

        btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        btn.layer.cornerRadius = 13
        btn.layer.borderWidth = 1
        btn.layer.borderColor = ColorD6D6D6.cgColor
        return btn
    }
    
    static func buildButton(title: String, image: String) -> QMUIButton {
        let btn = QMUIButton()
        btn.setTitle(title, for: .normal)
        btn.setImage(UIImage(named: image), for: .normal)
        btn.setTitleColor(Color979797, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.imagePosition = .top
        return btn
    }
}
