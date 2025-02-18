//
//  LiveListExponentFootballCell.swift
//  SportNews
//
//  Created by yuhua on 2021/3/12.
//

import UIKit

/// 指数数据变动模型
@objc class ChangeModel: NSObject {
    
    @objc var fyz = false
    @objc var foz = false
    @objc var fsz = false
    @objc var bt1 = false
    @objc var bt2 = false
    @objc var bf = false
    
    @objc func changeToFalse() {
        fyz = false
        foz = false
        fsz = false
        bt1 = false
        bt2 = false
        bf = false
    }
}

/// cell数据模型
class CellModel: NSObject {
    
    @objc internal init(name: String,
                time: String,
                t1Name: String,
                t1ImageUrl: String,
                t1Score: String,
                t2Name: String,
                t2ImageUrl: String,
                t2Score: String,
                basketballT1: [String],
                basketballT2: [String],
                footballL1: [String],
                footballL2: [String],
                footballL3: [String],
                videos: [[String]],
                ban: String,
                jiao: String,
                listType: NSInteger,
                status: NSInteger,
                changeModel: ChangeModel,
                t1New: Bool,
                t2New: Bool,
                vsID: Int,
                clogo: String) {
        self.name = name
        self.time = time
        self.t1Name = t1Name
        self.t1ImageUrl = t1ImageUrl
        self.t1Score = t1Score
        self.t2Name = t2Name
        self.t2ImageUrl = t2ImageUrl
        self.t2Score = t2Score
        self.basketballT1 = basketballT1
        self.basketballT2 = basketballT2
        self.footballL1 = footballL1
        self.footballL2 = footballL2
        self.footballL3 = footballL3
        self.videos = videos
        self.ban = ban
        self.jiao = jiao
        self.listType = listType
        self.status = status
        self.changeModel = changeModel
        self.vsID = vsID
        isT1New = t1New
        isT2New = t2New
        self.clogo = clogo
    }
    
    @objc static var showID: Int = -1
    @objc static var moreView: MoreView?
    var vsID: Int
    /// 比赛名字
    var name: String
    /// 比赛时间
    var time: String
    /// 队伍1名字
    var t1Name: String
    /// 队伍1图片地址
    var t1ImageUrl: String
    /// 队伍1分数
    var t1Score: String
    /// 队伍2名字
    var t2Name: String
    /// 队伍2图片地址
    var t2ImageUrl: String
    /// 队伍2分数
    var t2Score: String
    /// 队伍1篮球指数数组，对应界面上面5个字符，传入5个数据，没有的传""
    var basketballT1: [String]
    /// 队伍2篮球指数数组，对应界面上面5个字符，传入5个数据，没有的传""
    var basketballT2: [String]
    /// 足球指数第一排，三个字符串，传入3个数据，没有的传""
    var footballL1: [String]
    /// 足球指数第二排，三个字符串，传入3个数据，没有的传""
    var footballL2: [String]
    /// 足球指数第三排，三个字符串，传入3个数据，没有的传""
    var footballL3: [String]
    /// 视频列表，格式：[["中文直播", "1"], ["高清", "0"], ["清晰", "1"],]
    /// 注意顺序，放首位的排最右边，1表示可用，正常色，0表示不可用，灰色
    var videos: [[String]]
    /// 半场
    var ban: String
    /// 角球
    var jiao: String
    /// 角球
    var listType: NSInteger
    /// 比赛状态：0 开赛中  1 未开赛  2 比赛结束 3 比赛推迟 4 未确定的 5 已取消的
    var status: NSInteger
    /// 指数信息是否是最新
    var changeModel: ChangeModel
    var isT1New: Bool
    var isT2New: Bool
    var clogo: String
}

class LiveListExponentFootballCell: QMUITableViewCell {
    
    /// 比赛名字 和 比赛节数
    let ltLabel = QMUILabel.buildPingLabel(text: "VTB联赛 第四节", textColor: Color979797, font: .systemFont(ofSize: 11), alignment: .left)
    /// 半
    let banLabel = QMUILabel.buildPingLabel(text: "VTB联赛", textColor: Color979797, font: .systemFont(ofSize: 11), alignment: .center)
    /// 角
    let jiaoLabel = QMUILabel.buildPingLabel(text: "VTB联赛", textColor: Color979797, font: .systemFont(ofSize: 11), alignment: .center)
    
    /// 比赛时间
    let gameLabel = QMUILabel.buildPingLabel(text: "21:00", textColor: UIColor(red: 0.98, green: 0.46, blue: 0.13, alpha: 1), font: .systemFont(ofSize: 11), alignment: .center)
    /// 那个点
    let dianLabel = QMUILabel.buildPingLabel(text: "‘", textColor: UIColor(red: 0.98, green: 0.46, blue: 0.13, alpha: 1), font: .systemFont(ofSize: 11), alignment: .center)
    
    /// 视频列表
    @objc let videoShow = VideoShow()
    /// 时间
    let timeLabel = QMUILabel.buildPingLabel(text: "21:00", textColor: Color333333, font: .systemFont(ofSize: 12, weight: .init(2)), alignment: .center)
    /// 队伍1
    let team1 = TeamView()
    /// 队伍2
    let team2 = TeamView()
    /// 亚指
    let YaZhiValue = ExponentView()
    /// 欧指
    let OuZhiValue = ExponentView()
    /// 大小指
    let SizeZhiValue = ExponentView()
    
    let more = MoreView()
    
    var model: CellModel?
    
    let huoImageView = UIImageView()
    
    let back = UIView()
    let line1 = UIView()
    
    @objc func reloadCell(model: CellModel) {
        
        self.model = model
        
        let array = model.name.components(separatedBy: " ")
        ltLabel.text = "\(array[1]) \(array[2])"
        if array.first?.count == 0 {
            gameLabel.text = ""
            gameLabel.isHidden = true
            dianLabel.layer.removeAllAnimations()
            dianLabel.isHidden = true
            jiaoLabel.mas_updateConstraints {
                $0?.left.equalTo()(dianLabel.mas_right)?.offset()(2)
            }
            
        }else {
            gameLabel.text = array.first
            gameLabel.isHidden = false
            dianLabel.layer.add(CommonTools.opacityForever_Animation(0.5), forKey: "opacityForeverAnimation")
            dianLabel.isHidden = false
            jiaoLabel.mas_updateConstraints {
                $0?.left.equalTo()(dianLabel.mas_right)?.offset()(7)
            }
        }
        
        banLabel.isHidden = model.status == 0 ? false : true
        jiaoLabel.isHidden = model.status == 0 ? false : true
        gameLabel.isHidden = model.status == 0 ? false : true
        dianLabel.isHidden = model.status == 0 ? false : true
        
        banLabel.text = "半:\(model.ban)"
        jiaoLabel.text = "角:\(model.jiao)"
        timeLabel.text = model.time
        team1.name.text = model.t1Name
        team1.value.setNewText(text: model.t1Score, animation: model.isT1New)
        team2.name.text = model.t2Name
        team2.value.setNewText(text: model.t2Score, animation: model.isT2New)
        if model.t1ImageUrl == "" {
            team1.image.sd_setImage(with: URL(string: model.clogo),
                                    placeholderImage: UIImage(named: "默认头像"))
        } else {
            team1.image.sd_setImage(with: URL(string: model.t1ImageUrl),
                                    placeholderImage: UIImage(named: "默认头像"))
        }

        if model.t2ImageUrl == "" {
            team2.image.sd_setImage(with: URL(string: model.clogo),
                                    placeholderImage: UIImage(named: "默认头像"))
        } else {
            team2.image.sd_setImage(with: URL(string: model.t2ImageUrl),
                                    placeholderImage: UIImage(named: "默认头像"))
        }
        YaZhiValue.l1.setNewText(text: model.footballL1[0], animation: model.changeModel.fyz)
        YaZhiValue.l1.backColor = getColor(code: model.footballL1[3])
        YaZhiValue.l2.setNewText(text: model.footballL1[1], animation: model.changeModel.fyz)
        YaZhiValue.l2.backColor = getColor(code: model.footballL1[4])
        YaZhiValue.l3.setNewText(text: model.footballL1[2], animation: model.changeModel.fyz)
        YaZhiValue.l3.backColor = getColor(code: model.footballL1[5])
        OuZhiValue.l1.setNewText(text: model.footballL2[0], animation: model.changeModel.foz)
        OuZhiValue.l1.backColor = getColor(code: model.footballL2[3])
        OuZhiValue.l2.setNewText(text: model.footballL2[1], animation: model.changeModel.foz)
        OuZhiValue.l2.backColor = getColor(code: model.footballL2[4])
        OuZhiValue.l3.setNewText(text: model.footballL2[2], animation: model.changeModel.foz)
        OuZhiValue.l3.backColor = getColor(code: model.footballL2[5])
        SizeZhiValue.l1.setNewText(text: model.footballL3[0], animation: model.changeModel.fsz)
        SizeZhiValue.l1.backColor = getColor(code: model.footballL3[3])
        SizeZhiValue.l2.setNewText(text: model.footballL3[1], animation: model.changeModel.fsz)
        SizeZhiValue.l2.backColor = getColor(code: model.footballL3[4])
        SizeZhiValue.l3.setNewText(text: model.footballL3[2], animation: model.changeModel.fsz)
        SizeZhiValue.l3.backColor = getColor(code: model.footballL3[5])
        
        var videos = [[String]]()
        for (index, value) in model.videos.enumerated() {
            videos.append([value[0], value[1], "\(index)", value[2]])
        }
        videoShow.reloadView(videos: videos)
        model.changeModel.changeToFalse()
        more.isHidden = CellModel.showID != self.model?.vsID
        if !more.isHidden {
            CellModel.moreView = more
        }
        
        if model.listType == 1 {
            huoImageView.isHidden = false;
            huoImageView.image = UIImage.init(named: "热门标记")
            huoImageView.animationImages = SNGlobalShare.sharedInstance().initialImageArray() as? [UIImage]
            //动画重复次数
            huoImageView.animationRepeatCount = 0
            //动画执行时间,多长时间执行完动画
            huoImageView.animationDuration = 1
            //开始动画
            huoImageView.startAnimating()
            
            timeLabel.mas_updateConstraints {
                $0?.left.equalTo()(back)?.equalTo()(14)
            }
            
        }else {
            huoImageView.isHidden = true
            huoImageView.stopAnimating()
            timeLabel.mas_updateConstraints {
                $0?.left.equalTo()(back)
            }
        }
    }
    
    func getColor(code: String) -> UIColor {
        if code == "1" {
            return Color27C5C3
        } else if code == "2" {
            return ColorDA4155
        } else {
            return Color333333
        }
    }
    
    @objc override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         
        back.backgroundColor = .white
        back.layer.cornerRadius = 13;
        back.layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.06).cgColor
        back.layer.shadowOffset = CGSize(width: 0, height: 2)
        back.layer.shadowOpacity = 1
        
        contentView.addSubview(back)
        contentView.backgroundColor = ColorFBFBFB
        
        back.mas_makeConstraints {
            $0?.left.equalTo()(contentView.mas_left)?.offset()(12.5)
            $0?.right.equalTo()(contentView.mas_right)?.offset()(-12.5)
            $0?.top.equalTo()(contentView.mas_top)?.offset()(3)
            $0?.bottom.equalTo()(contentView.mas_bottom)?.offset()(-5)
        }
         
        line1.backgroundColor = ColorEAEAEA
        back.addSubview(line1)
        line1.mas_makeConstraints {
            $0?.left.equalTo()(back)?.offset()(15)
            $0?.right.equalTo()(back)?.offset()(-15)
            $0?.top.equalTo()(back)?.offset()(25)
            $0?.height.equalTo()(0.5)
        }
        
        back.addSubview(banLabel)
        banLabel.mas_makeConstraints {
            $0?.top.equalTo()(back)
            $0?.left.equalTo()(line1)
            $0?.bottom.equalTo()(line1.mas_top)
        }
        
        back.addSubview(gameLabel)
        gameLabel.mas_makeConstraints {
            $0?.top.equalTo()(back)
            $0?.left.equalTo()(banLabel.mas_right)?.offset()(7)
            $0?.bottom.equalTo()(line1.mas_top)
        }
        
        back.addSubview(dianLabel)
        dianLabel.mas_makeConstraints {
            $0?.top.equalTo()(back)
            $0?.left.equalTo()(gameLabel.mas_right)
            $0?.bottom.equalTo()(line1.mas_top)
        }
        
        back.addSubview(jiaoLabel)
        jiaoLabel.mas_makeConstraints {
            $0?.top.equalTo()(back)
            $0?.left.equalTo()(dianLabel.mas_right)?.offset()(7)
            $0?.bottom.equalTo()(line1.mas_top)
        }
        
        back.addSubview(videoShow)
        videoShow.mas_makeConstraints {
            $0?.left.equalTo()(jiaoLabel.mas_right)
            $0?.right.equalTo()(line1)
            $0?.top.equalTo()(back)
            $0?.bottom.equalTo()(line1.mas_top)
        }
        
        let line2 = UIView()
        line2.backgroundColor = ColorEAEAEA
        back.addSubview(line2)
        line2.mas_makeConstraints {
            $0?.right.equalTo()(back)?.offset()(-152)
            $0?.bottom.equalTo()(back)?.offset()(-13)
            $0?.top.equalTo()(line1.mas_bottom)?.offset()(13)
            $0?.width.equalTo()(0.5)
        }
        
        back.addSubview(timeLabel)
        timeLabel.mas_makeConstraints {
            $0?.left.equalTo()(back) 
            $0?.top.equalTo()(line1.mas_bottom)?.offset()(17.5)
            $0?.width.equalTo()(30 + 40)
        }
        
        back.addSubview(huoImageView)
        huoImageView.mas_makeConstraints {
            $0?.left.equalTo()(back)?.equalTo()(10)
            $0?.centerY.equalTo()(timeLabel.mas_centerY)?.offset()(-2)
            $0?.height.equalTo()(20)
            $0?.width.equalTo()(20)
        }
        
        back.addSubview(ltLabel)
        ltLabel.numberOfLines = 2
        ltLabel.mas_makeConstraints {
            $0?.left.equalTo()(back)?.offset()(15)
            $0?.top.equalTo()(timeLabel.mas_bottom)?.offset()(2)
            $0?.width.equalTo()(59)
        }
        
        back.addSubview(team1)
        team1.mas_makeConstraints {
            $0?.left.equalTo()(timeLabel.mas_right)
            $0?.right.equalTo()(line2.mas_left)?.offset()(-5)
            $0?.top.equalTo()(line1.mas_bottom)
        }
        
        back.addSubview(team2)
        team2.mas_makeConstraints {
            $0?.left.equalTo()(team1)
            $0?.bottom.equalTo()(back)
            $0?.top.equalTo()(team1.mas_bottom)?.offset()(1)
            $0?.right.equalTo()(team1)
            $0?.height.equalTo()(team1)
        }
        
        back.addSubview(YaZhiValue)
        YaZhiValue.mas_makeConstraints {
            $0?.left.equalTo()(line2.mas_right)?.offset()(10)
            $0?.centerY.equalTo()(team1.mas_centerY)
            $0?.height.equalTo()(20)
            $0?.right.equalTo()(line1)
        }
        
        
        back.addSubview(SizeZhiValue)
        SizeZhiValue.mas_makeConstraints {
            $0?.left.equalTo()(YaZhiValue)
            $0?.centerY.equalTo()(team2.mas_centerY)
            $0?.height.equalTo()(20)
            $0?.right.equalTo()(YaZhiValue)
        }
        
        back.addSubview(OuZhiValue)
        OuZhiValue.mas_makeConstraints {
            $0?.left.equalTo()(YaZhiValue)
            $0?.top.equalTo()(YaZhiValue.mas_bottom)
            $0?.bottom.equalTo()(SizeZhiValue.mas_top)
            $0?.right.equalTo()(YaZhiValue)
        }  
        
        videoShow.more = { [weak self] in
            if CellModel.showID == self?.model?.vsID {
                CellModel.showID = -1
                CellModel.moreView?.isHidden = true
                CellModel.moreView = nil
            } else {
                CellModel.showID = self?.model?.vsID ?? -1
                CellModel.moreView?.isHidden = true
                CellModel.moreView = self?.more
                CellModel.moreView?.isHidden = false
            }
        }
        videoShow.reloadData = { [weak self] content in
            guard let `self` = self else {
                return
            }
            self.more.mas_makeConstraints {
                $0?.width.equalTo()(100)
                $0?.right.equalTo()(self.back)?.offset()(-5)
                $0?.top.equalTo()(self.line1.mas_bottom)?.offset()(5)
                $0?.height.equalTo()(20 * min(3, content.count))
            }
            self.more.content = content
            self.more.tableView.reloadData()
        }
        more.tap = { [weak self] content in
            self?.videoShow.tap?(Int(content[2]) ?? -1)
        }
        back.addSubview(more)
        more.mas_makeConstraints {
            $0?.width.equalTo()(100)
            $0?.right.equalTo()(back)?.offset()(-5)
            $0?.top.equalTo()(line1.mas_bottom)?.offset()(5)
            $0?.height.equalTo()(60)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MoreView: UIView, QMUITableViewDelegate, QMUITableViewDataSource {
    
    let tableView = QMUITableView()
    var content: [[String]]?
    var tap: (([String])->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = ColorF0F0F0
        tableView.layer.cornerRadius = 5
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MoreCellV")
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
        tableView.mas_makeConstraints {
            $0?.edges.equalTo()(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = content![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCellV", for: indexPath)
        cell.backgroundColor = .clear
        let item = VideoItem()
        item.isUserInteractionEnabled = false
        item.reloadItem(name: video.first ?? "", status: video[1], indexStr: video.last ?? "")
        cell.contentView.qmui_removeAllSubviews()
        cell.contentView.addSubview(item)
        item.mas_makeConstraints {
            $0?.center.equalTo()(cell.contentView)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tap?(content![indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
}


class VideoShow: UIView {
    
    @objc var tap: ((Int)->Void)?
    var more: (()->Void)?
    var reloadData: (([[String]])->Void)?
    
    func reloadView(videos: [[String]]) {
        qmui_removeAllSubviews()
        let maxCount = 3
        let max = min(maxCount, videos.count)
        var up: VideoItem?
        var first: VideoItem?
        for index in videos.count-max..<videos.count {
            let item = VideoItem()
            item.tap = tap
            let video = videos[index]
            item.tag = Int(video[2]) ?? 0
            item.reloadItem(name: video.first ?? "", status: video[1], indexStr: video.last ?? "")
            addSubview(item)
            if index == videos.count-max {
                first = item
                item.mas_makeConstraints {
                    $0?.right.equalTo()(self)?.offset()(-10)
                    $0?.bottom.equalTo()(self)
                    $0?.top.equalTo()(self)
                }
            } else {
                item.mas_makeConstraints {
                    $0?.right.equalTo()(up!.mas_left)?.offset()(-10)
                    $0?.bottom.equalTo()(self)
                    $0?.top.equalTo()(self)
                }
            }
            up = item
        }
        if videos.count > maxCount {
            let more = QMUIButton()
            more.addTarget(self, action: #selector(moreSelected), for: .touchUpInside)
            more.setImage(UIImage(named: "更多"), for: .normal)
            addSubview(more)
            reloadData?([[String]](videos[0..<videos.count-maxCount]))
            more.mas_makeConstraints {
                $0?.right.equalTo()(self)
                $0?.bottom.equalTo()(self)
                $0?.top.equalTo()(self)
                $0?.width.equalTo()(20)
            }
            first?.mas_updateConstraints {
                $0?.right.equalTo()(self)?.offset()(-30)
                $0?.bottom.equalTo()(self)
                $0?.top.equalTo()(self)
            }
        } else {
            first?.mas_updateConstraints {
                $0?.right.equalTo()(self)?.offset()(-10)
                $0?.bottom.equalTo()(self)
                $0?.top.equalTo()(self)
            }
        }
    }
    
    @objc
    func moreSelected() {
        more?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoItem: UIView {
    
    let lable = QMUILabel.buildPingLabel(text: "中文直播", textColor: Color333333, font: .systemFont(ofSize: 11), alignment: .center)
    let image = UIImageView()
    
    var index: Int = 0
    
    var tap: ((Int)->Void)?
    
    func reloadItem(name: String, status: String, indexStr: String) {
        lable.text = name
        if status == "0" {
            lable.textColor = Color979797
        }
        index = Int(indexStr)!
        
        if name == "中文" || index == 1 {
            if status == "0" {
                image.image = UIImage(named: "中文标清禁用")
            } else {
                image.image = UIImage(named: "中文标清-lv")
            }
        } else if name == "高清" || index == 2 {
            if status == "0" {
                image.image = UIImage(named: "高清禁用")
            } else {
                image.image = UIImage(named: "高清-lv")
            }
        } else if name == "标清" || index == 4 {
            if status == "0" {
                image.image = UIImage(named: "标清禁用")
            } else {
                image.image = UIImage(named: "标清")
            }
        } else if name == "动画" || index == 10 {
            if status == "0" {
                image.image = UIImage(named: "动画直播禁用")
            } else {
                image.image = UIImage(named: "动画直播")
            }
        } else {
            image.image = UIImage(named: "主播")
            if status == "0" {
                image.alpha = 0.5
            } else {
                image.alpha = 1
            }
        }
    }
    
    @objc func tapView() {
        tap?(tag)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView))
        addGestureRecognizer(tap)
        
        addSubview(lable)
        addSubview(image)
        image.contentMode = .center
        
        lable.mas_makeConstraints {
            $0?.bottom.equalTo()(self)
            $0?.top.equalTo()(self)
            $0?.right.equalTo()(self)
        }
        image.mas_makeConstraints {
            $0?.left.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.top.equalTo()(self)
            $0?.width.equalTo()(14)
            $0?.right.equalTo()(lable.mas_left)?.offset()(-4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TeamView: UIView {
    
    let value = TextAnimationLabel.buildPingLabel(text: "144", textColor: Color555555, font: .systemFont(ofSize: 13, weight: .init(2)), alignment: .center)
    let image = UIImageView(image: UIImage.init(named: "默认头像"))
    let name = QMUILabel.buildPingLabel(text: String(repeating: "队伍21", count: 1), textColor: Color333333, font: .systemFont(ofSize: 12), alignment: .right)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(value)
        value.mas_makeConstraints {
            $0?.width.equalTo()(20+16)
            $0?.bottom.equalTo()(self)
            $0?.top.equalTo()(self)
            $0?.right.equalTo()(self)
        }
        
        addSubview(image)
        image.mas_makeConstraints {
            $0?.width.height().equalTo()(20)
            $0?.centerY.equalTo()(value.mas_centerY)
            $0?.right.equalTo()(value.mas_left)
        }
        
        addSubview(name)
        name.numberOfLines = 2
        name.mas_makeConstraints {
            $0?.left.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.top.equalTo()(self)
            $0?.right.equalTo()(image.mas_left)?.offset()(-7)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ExponentView: UIView {
    
    let l1 = TextAnimationLabel.buildPingLabel(text: "1.85", textColor: Color333333, font: .systemFont(ofSize: 12), alignment: .center)
    let l2 = TextAnimationLabel.buildPingLabel(text: "2.33", textColor: Color333333, font: .systemFont(ofSize: 12), alignment: .center)
    let l3 = TextAnimationLabel.buildPingLabel(text: "4.56", textColor: Color333333, font: .systemFont(ofSize: 12), alignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [l1, l2, l3].forEach {
            addSubview($0)
        }
        
        l1.mas_makeConstraints {
            $0?.left.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.top.equalTo()(self)
        }
        
        buildConstraints(l1: l1, l2: l2)
        
        l3.mas_makeConstraints {
            $0?.left.equalTo()(l2.mas_right)
            $0?.bottom.equalTo()(self)
            $0?.top.equalTo()(self)
            $0?.right.equalTo()(self)
            $0?.width.equalTo()(l2)
        }
    }
    
    /// l1被依赖  l2需设置依赖
    func buildConstraints(l1: QMUILabel, l2: QMUILabel) {
        l2.mas_makeConstraints {
            $0?.left.equalTo()(l1.mas_right)
            $0?.bottom.equalTo()(self)
            $0?.top.equalTo()(self)
            $0?.width.equalTo()(l1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
