//
//  SNPlayerDetailVC.swift
//  SportNews
//
//  Created by yuhua on 2021/3/26.
//

import UIKit

class SNPlayerDetailVC: QMUICommonViewController {
    
    /// 保持vc
    static var handle: SNPlayerDetailVC?
    /// 背景遮罩view
    let backView = UIView(frame: UIScreen.main.bounds)
    
    /// 数据模型
    var model: SNPlayerDetail? {
        didSet { 
            name.text = model?.player_name
            let attributedText = NSMutableAttributedString(string: "\(model?.team_name ?? "") ", attributes: [NSAttributedString.Key.foregroundColor: Color979797, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)])
            attributedText.append(NSAttributedString(string: model?.shirt_number ?? "", attributes: [NSAttributedString.Key.foregroundColor: ColorDA4155, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            attributedText.append(NSAttributedString(string: " 号", attributes: [NSAttributedString.Key.foregroundColor: Color979797, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]))
            num.attributedText = attributedText
            location.text = "\(model?.shanchangweizhi ?? "")  \(model?.guanyongjiao ?? "")"
            imageView.sd_setImage(with: URL(string: model?.logo ?? ""), placeholderImage: UIImage(named: "默认头像"))
            fen.text = String(format: "%0.1f", model?.pingfen ?? 0)
            shoufachangci.text = "\(model?.shoufa ?? 0)"
            yinglv.text = model?.win_rate
            chuchang.value.text = model?.chuchang
            jinqiu.value.text = model?.jinqiu_dianqiu
            zhugong.value.text = "\(model?.zhugong ?? 0)"
            shemen.value.text = model?.shemen_shezheng
            guomen.value.text = model?.guoren_chenggong
            chuangqiu.value.text = model?.chuanqiu_chenggong
            weixie.value.text = "\(model?.weixie_chuanqiu ?? 0)"
            qinfan.value.text = "\(model?.bei_qinfan ?? 0)"
            fangui.value.text = model?.fangui_yuewei
            fengdu.value.text = "\(model?.fengdu_shemen ?? 0)"
            jiewei.value.text = "\(model?.jiewei ?? 0)"
            duanqiu.value.text = "\(model?.duanqiu ?? 0)"
            huangpai.value.text = "\(model?.huangpai ?? 0)"
            hongpai.value.text = "\(model?.hongpai ?? 0)"
        }
    }
    
    /// 关闭按钮
    let close = QMUIButton()
    let closeBottom = QMUIButton()
    /// 头像
    let imageView = UIImageView()
    /// 名字
    let name = QMUILabel.buildPingLabel(text: "", textColor: Color333333, font: .systemFont(ofSize: 14, weight: .bold), alignment: .left)
    /// 号码
    let num = QMUILabel.buildPingLabel(text: "", textColor: Color979797, font: .systemFont(ofSize: 10), alignment: .left)
    /// 位置
    let location = QMUILabel.buildPingLabel(text: "", textColor: Color979797, font: .systemFont(ofSize: 10), alignment: .left)
    
    /// 分
    let fenBack = UIView()
    /// 分
    let fen = QMUILabel.buildPingLabel(text: "", textColor: .white, font: .systemFont(ofSize: 10), alignment: .center)
    /// 分文字
    let fenText = QMUILabel.buildPingLabel(text: "本场评分", textColor: ColorDA4155, font: .systemFont(ofSize: 10), alignment: .center)
    /// 首发文字
    let shoufaText = QMUILabel.buildPingLabel(text: "首发数据", textColor: Color333333, font: .systemFont(ofSize: 14, weight: .bold), alignment: .left)
    /// 首发场次
    let shoufachangci = QMUILabel.buildPingLabel(text: "", textColor: Color333333, font: .systemFont(ofSize: 18, weight: .bold), alignment: .center)
    /// 首发场次文字
    let shoufachangciText = QMUILabel.buildPingLabel(text: "首发场次", textColor: Color979797, font: .systemFont(ofSize: 10), alignment: .center)
    /// 赢率
    let yinglv = QMUILabel.buildPingLabel(text: "", textColor: ColorDA4155, font: .systemFont(ofSize: 18, weight: .bold), alignment: .center)
    /// 首发场次文字
    let yinglvText = QMUILabel.buildPingLabel(text: "赢率", textColor: Color979797, font: .systemFont(ofSize: 10), alignment: .center)
    /// 全场表现
    let quanchangText = QMUILabel.buildPingLabel(text: "全场表现", textColor: Color333333, font: .systemFont(ofSize: 14, weight: .bold), alignment: .left)
    /// 出场
    let chuchang = ShowView()
    /// 进球
    let jinqiu = ShowView()
    /// 助攻
    let zhugong = ShowView()
    /// 射门
    let shemen = ShowView()
    /// 过人
    let guomen = ShowView()
    /// 传球
    let chuangqiu = ShowView()
    /// 威胁
    let weixie = ShowView()
    /// 被侵犯
    let qinfan = ShowView()
    /// 犯规
    let fangui = ShowView()
    /// 封堵射门
    let fengdu = ShowView()
    /// 解围
    let jiewei = ShowView()
    /// 断球
    let duanqiu = ShowView()
    /// 黄牌
    let huangpai = ShowView()
    /// 红牌
    let hongpai = ShowView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.frame = CGRect(x: 20, y: 60, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height-120)
        view.layer.cornerRadius = 5
        
        close.setImage(UIImage(named: "关闭"), for: .normal)
        view.addSubview(close)
        close.mas_makeConstraints {
            $0?.top.equalTo()(view)?.offset()(10)
            $0?.right.equalTo()(view)?.offset()(-10)
            $0?.size.mas_equalTo()(CGSize(width: 13, height: 13))
        }
        close.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        closeBottom.setTitle("关闭", for: .normal)
        closeBottom.setTitleColor(Color979797, for: .normal)
        closeBottom.backgroundColor = ColorFBFBFB
        closeBottom.layer.cornerRadius = 5
        view.addSubview(closeBottom)
        closeBottom.mas_makeConstraints {
            $0?.bottom.equalTo()(view)?.offset()(-16)
            $0?.left.equalTo()(view)?.offset()(16)
            $0?.right.equalTo()(view)?.offset()(-16)
            $0?.height.mas_equalTo()(40)
        }
        closeBottom.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        let l1 = UIView()
        l1.backgroundColor = Color27C5C3
        l1.layer.cornerRadius = 1.5
        let l2 = UIView()
        l2.layer.cornerRadius = 1.5
        l2.backgroundColor = Color27C5C3
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        [imageView, name, num, location, fenBack, fen, fenText, shoufaText, shoufachangci, shoufachangciText, yinglv, yinglvText, yinglv, yinglvText, quanchangText,
        chuchang, jinqiu, zhugong, shemen, guomen, chuangqiu, weixie, qinfan, fangui, fengdu, jiewei, duanqiu, huangpai, hongpai, l1, l2].forEach {
            view.addSubview($0)
        }
        imageView.mas_makeConstraints {
            $0?.top.equalTo()(view)?.offset()(33)
            $0?.left.equalTo()(view)?.offset()(12)
            $0?.size.mas_equalTo()(CGSize(width: 50, height: 50))
        }
        name.mas_makeConstraints {
            $0?.top.equalTo()(imageView)
            $0?.left.equalTo()(imageView.mas_right)?.offset()(9)
            $0?.height.mas_equalTo()(14)
        }
        num.mas_makeConstraints {
            $0?.top.equalTo()(name.mas_bottom)?.offset()(5)
            $0?.left.equalTo()(name)
            $0?.height.mas_equalTo()(20)
        }
        location.mas_makeConstraints {
            $0?.top.equalTo()(num.mas_bottom)?.offset()(5)
            $0?.left.equalTo()(num)
            $0?.height.mas_equalTo()(10)
        }
        
        fenBack.layer.cornerRadius = 7.5
        fenBack.layer.masksToBounds = true
        fenBack.mas_makeConstraints {
            $0?.size.mas_equalTo()(CGSize(width: 30, height: 15))
            $0?.centerY.equalTo()(imageView)?.offset()(-10)
            $0?.right.equalTo()(view)?.offset()(-20)
        }
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.1, green: 0.67, blue: 0.96, alpha: 1).cgColor, UIColor(red: 0.31, green: 0.9, blue: 0.66, alpha: 1).cgColor]
        gradient.locations = [0, 1]
        gradient.frame = CGRect.init(x: 0, y: 0, width: 30, height: 15)
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        fenBack.layer.addSublayer(gradient)
        
        fen.backgroundColor = UIColor.clear
        fen.layer.cornerRadius = 7.5
        fen.layer.masksToBounds = true
        fen.mas_makeConstraints {
            $0?.size.mas_equalTo()(CGSize(width: 30, height: 15))
            $0?.centerY.equalTo()(imageView)?.offset()(-10)
            $0?.right.equalTo()(view)?.offset()(-20)
        }
         
        fenText.mas_makeConstraints {
            $0?.centerX.equalTo()(fen)
            $0?.top.equalTo()(fen.mas_bottom)?.offset()(5)
        }
        shoufaText.mas_makeConstraints {
            $0?.top.equalTo()(imageView.mas_bottom)?.offset()(20)
            $0?.left.equalTo()(view)?.offset()(20)
            $0?.height.equalTo()(20)
        }
        let center = (UIScreen.main.bounds.width-40)/6
        shoufachangci.mas_makeConstraints {
            $0?.centerX.equalTo()(-center)
            $0?.top.equalTo()(shoufaText.mas_bottom)?.offset()(20)
            $0?.height.equalTo()(20)
        }
        shoufachangciText.mas_makeConstraints {
            $0?.centerX.equalTo()(shoufachangci)
            $0?.top.equalTo()(shoufachangci.mas_bottom)?.offset()(5)
            $0?.height.equalTo()(20)
        }
        yinglv.mas_makeConstraints {
            $0?.centerX.equalTo()(center)
            $0?.top.equalTo()(shoufachangci)
            $0?.height.equalTo()(20)
        }
        yinglvText.mas_makeConstraints {
            $0?.centerX.equalTo()(yinglv)
            $0?.top.equalTo()(shoufachangciText)
            $0?.height.equalTo()(20)
        }
        quanchangText.mas_makeConstraints {
            $0?.top.equalTo()(yinglvText.mas_bottom)?.offset()(20)
            $0?.left.equalTo()(view)?.offset()(20)
            $0?.height.equalTo()(20)
        }
        chuchang.title.text = "出场分钟"
        jinqiu.title.text = "进球(点球)"
        zhugong.title.text = "助攻"
        shemen.title.text = "射门(射正)"
        guomen.title.text = "过人(成功)"
        chuangqiu.title.text = "传球(成功)"
        weixie.title.text = "威胁(传球)"
        qinfan.title.text = "被侵犯"
        fangui.title.text = "犯规(越位)"
        fengdu.title.text = "封堵射门"
        jiewei.title.text = "解围"
        duanqiu.title.text = "断球"
        huangpai.title.text = "黄牌"
        hongpai.title.text = "红牌"
        chuchang.mas_makeConstraints {
            $0?.top.equalTo()(quanchangText.mas_bottom)?.offset()(10)
            $0?.left.equalTo()(view)
            $0?.right.equalTo()(view)
        }
        var up = chuchang
        [jinqiu, zhugong, shemen, guomen, chuangqiu, weixie, qinfan, fangui, fengdu, jiewei, duanqiu, huangpai].forEach {
            var other = 5
            if ($0 == shemen || $0 == fangui) {
                other = 15
            }
            $0.mas_makeConstraints {
                $0?.top.equalTo()(up.mas_bottom)?.offset()(CGFloat(other))
                $0?.left.equalTo()(up)
                $0?.height.equalTo()(up)
                $0?.right.equalTo()(up)
            }
            up = $0
        }
        hongpai.mas_makeConstraints {
            $0?.top.equalTo()(up.mas_bottom)?.offset()(5)
            $0?.left.equalTo()(up)
            $0?.right.equalTo()(up)
            $0?.height.equalTo()(up)
            $0?.bottom.equalTo()(closeBottom.mas_top)?.offset()(-10)
        }
        
        l1.mas_makeConstraints {
            $0?.height.equalTo()(shoufaText)
            $0?.centerY.equalTo()(shoufaText)
            $0?.width.equalTo()(3)
            $0?.right.equalTo()(shoufaText.mas_left)?.offset()(-3)
        }
        l2.mas_makeConstraints {
            $0?.height.equalTo()(quanchangText)
            $0?.centerY.equalTo()(quanchangText)
            $0?.width.equalTo()(3)
            $0?.right.equalTo()(quanchangText.mas_left)?.offset()(-3)
        }
    }
    
    deinit {
        print("\(type(of: self))销毁了")
    }
    
    /// 弹出
    @objc static func show(model: SNPlayerDetail) {
        let vc = SNPlayerDetailVC()
        vc.show()
        vc.model = model
    }
    
    /// 弹出
    func show() {
        SNPlayerDetailVC.handle = self
        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        backView.addSubview(view)
        let window = UIApplication.shared.delegate!.window!
        window?.addSubview(backView)
    }
    /// 外部手动消失
    @objc static func dismissVC() {
        SNPlayerDetailVC.handle?.dismissVC()
    }
    /// 消失
    @objc private func dismissVC() {
        backView.removeFromSuperview()
        LiveListCalendarVC.handle = nil
    }
}

class ShowView: UIView {
    let title = QMUILabel.buildPingLabel(text: "", textColor: Color333333, font: .systemFont(ofSize: 12), alignment: .left)
    let value = QMUILabel.buildPingLabel(text: "", textColor: Color333333, font: .systemFont(ofSize: 12), alignment: .right)
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        addSubview(value)
        title.mas_makeConstraints {
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.left.equalTo()(self)?.offset()(20)
        }
        value.mas_makeConstraints {
            $0?.top.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.right.equalTo()(self)?.offset()(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
