//
//  LiveListExponentBasketballCell.swift
//  SportNews
//
//  Created by yuhua on 2021/3/12.
//

import UIKit

class LiveListExponentBasketballCell: QMUITableViewCell {
 
    /// 比赛名字
    let ltLabel = QMUILabel.buildPingLabel(text: "VTB联赛", textColor: Color979797, font: .systemFont(ofSize: 11), alignment: .center)
    /// 视频列表
    @objc let videoShow = VideoShow()
    
    /// 比赛时间
    let gameLabel = QMUILabel.buildPingLabel(text: "21:00", textColor: UIColor(red: 0.98, green: 0.46, blue: 0.13, alpha: 1), font: .systemFont(ofSize: 11), alignment: .center)
    /// 那个点
    let dianLabel = QMUILabel.buildPingLabel(text: "‘", textColor: UIColor(red: 0.98, green: 0.46, blue: 0.13, alpha: 1), font: .systemFont(ofSize: 11), alignment: .center)
    
    /// 开始时间
    let timeLabel = QMUILabel.buildPingLabel(text: "21:00", textColor: Color333333, font: .systemFont(ofSize: 12, weight: .init(2)), alignment: .center)
    
    /// 队伍1
    let team1 = TeamView()
    /// 队伍2
    let team2 = TeamView()
    /// 队伍1
    let team1Value = ScoreView()
    /// 队伍2
    let team2Value = ScoreView()
    
    let huoImageView = UIImageView()
    
    let more = MoreView()
    
    var model: CellModel?

    let back = UIView()
    let line1 = UIView()
    
    @objc func reloadCell(model: CellModel) {
        
        self.model = model
        
        let array = model.name.components(separatedBy: " ")
        ltLabel.text = String(format: "%@ %@", array[1], array[2])
        if array.first?.count == 0 {
            ltLabel.mas_updateConstraints {
                $0?.left.equalTo()(dianLabel.mas_right)?.offset()(-3.5)
            }
            gameLabel.text = ""
            gameLabel.isHidden = true
            dianLabel.layer.removeAllAnimations()
            dianLabel.isHidden = true
            
        }else {
            gameLabel.text = array.first
            gameLabel.isHidden = false
            dianLabel.layer.add(CommonTools.opacityForever_Animation(0.5), forKey: "opacityForeverAnimation")
            dianLabel.isHidden = false
            ltLabel.mas_updateConstraints {
                $0?.left.equalTo()(dianLabel.mas_right)?.offset()(5)
            }
        }
        timeLabel.text = model.time
        team1.name.text = model.t1Name
        team1.value.setNewText(text: model.t1Score, animation: model.isT1New)
        team2.name.text = model.t2Name
        team2.value.setNewText(text: model.t2Score, animation: model.isT2New)
        team1.image.sd_setImage(with: URL(string: model.t1ImageUrl),
                                placeholderImage: UIImage(named: "默认头像"))
        team2.image.sd_setImage(with: URL(string: model.t2ImageUrl),
                                placeholderImage: UIImage(named: "默认头像"))
        team1Value.l1.setNewText(text: model.basketballT1[0], animation: model.changeModel.bf)
        team1Value.l2.setNewText(text: model.basketballT1[1], animation: model.changeModel.bt2)
        team1Value.l3.setNewText(text: model.basketballT1[2], animation: model.changeModel.bt2)
        team1Value.l4.setNewText(text: model.basketballT1[3], animation: model.changeModel.bt2)
        team1Value.l5.setNewText(text: model.basketballT1[4], animation: model.changeModel.bt2)
        team1Value.l6.setNewText(text: model.basketballT1[5], animation: model.changeModel.bt2)
        
        team2Value.l1.setNewText(text: model.basketballT2[0], animation: model.changeModel.bf)
        team2Value.l2.setNewText(text: model.basketballT2[1], animation: model.changeModel.bt1)
        team2Value.l3.setNewText(text: model.basketballT2[2], animation: model.changeModel.bt1)
        team2Value.l4.setNewText(text: model.basketballT2[3], animation: model.changeModel.bt1)
        team2Value.l5.setNewText(text: model.basketballT2[4], animation: model.changeModel.bt1)
        team2Value.l6.setNewText(text: model.basketballT2[5], animation: model.changeModel.bt1)
        
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
    
    @objc override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        back.backgroundColor = .white
        back.layer.cornerRadius = 13
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
         
        back.addSubview(gameLabel)
        gameLabel.mas_makeConstraints {
            $0?.top.equalTo()(back)
            $0?.left.equalTo()(line1)
            $0?.bottom.equalTo()(line1.mas_top)
        }
        
        back.addSubview(dianLabel)
        dianLabel.mas_makeConstraints {
            $0?.top.equalTo()(back)
            $0?.left.equalTo()(gameLabel.mas_right)
            $0?.bottom.equalTo()(line1.mas_top)
        }
        
        back.addSubview(ltLabel)
        ltLabel.mas_makeConstraints {
            $0?.top.equalTo()(back)
            $0?.left.equalTo()(dianLabel.mas_right)?.offset()(5)
            $0?.bottom.equalTo()(line1.mas_top)
        }
        
        back.addSubview(videoShow)
        videoShow.mas_makeConstraints {
            $0?.left.equalTo()(ltLabel.mas_right)?.offset()(5)
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
            $0?.bottom.equalTo()(back)
            $0?.top.equalTo()(line1.mas_bottom)
            $0?.width.equalTo()(30 + 40)
        }
        
        back.addSubview(huoImageView)
        huoImageView.mas_makeConstraints {
            $0?.left.equalTo()(back)?.equalTo()(10)
            $0?.centerY.equalTo()(timeLabel.mas_centerY)?.offset()(-2)
            $0?.height.equalTo()(20)
            $0?.width.equalTo()(20)
        }
        
        
        back.addSubview(team1)
        team1.mas_makeConstraints {
            $0?.left.equalTo()(timeLabel.mas_right)
            $0?.right.equalTo()(line2.mas_left)?.offset()(-5)
            $0?.top.equalTo()(line1.mas_bottom)?.offset()(5)
        }
        
        back.addSubview(team2)
        team2.mas_makeConstraints {
            $0?.left.equalTo()(team1)
            $0?.bottom.equalTo()(back)?.offset()(-5)
            $0?.top.equalTo()(team1.mas_bottom)?.offset()(1)
            $0?.right.equalTo()(team1)
            $0?.height.equalTo()(team1)
        }
        
        back.addSubview(team1Value)
        team1Value.mas_makeConstraints {
            $0?.left.equalTo()(line2.mas_right)?.offset()(6)
            $0?.centerY.equalTo()(team1.mas_centerY)
            $0?.height.equalTo()(20)
            $0?.right.equalTo()(line1)?.offset()(5)
        }
        
        
        back.addSubview(team2Value)
        team2Value.mas_makeConstraints {
            $0?.left.equalTo()(team1Value)
            $0?.centerY.equalTo()(team2.mas_centerY)
            $0?.height.equalTo()(20)
            $0?.right.equalTo()(team1Value)
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

class ScoreView: UIView {
    
    let l1 = TextAnimationLabel.buildPingLabel(text: "封", textColor: UIColor(red: 0.98, green: 0.46, blue: 0.13, alpha: 1), font: .systemFont(ofSize: 12), alignment: .center)
    let l2 = TextAnimationLabel.buildPingLabel(text: "", textColor: Color333333, font: .systemFont(ofSize: 12), alignment: .center)
    let l3 = TextAnimationLabel.buildPingLabel(text: "", textColor: Color333333, font: .systemFont(ofSize: 12), alignment: .center)
    let l4 = TextAnimationLabel.buildPingLabel(text: "", textColor: Color333333, font: .systemFont(ofSize: 12), alignment: .center)
    let l5 = TextAnimationLabel.buildPingLabel(text: "", textColor: Color333333, font: .systemFont(ofSize: 12), alignment: .center)
    let l6 = TextAnimationLabel.buildPingLabel(text: "", textColor: Color333333, font: .systemFont(ofSize: 12), alignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        l1.adjustsFontSizeToFitWidth = true;
        
        [l1, l2, l3, l4, l5, l6].forEach {
            addSubview($0)
        }
        
        l1.mas_makeConstraints {
            $0?.left.equalTo()(self)
            $0?.bottom.equalTo()(self)
            $0?.top.equalTo()(self)
        }
        
        l2.mas_makeConstraints {
            $0?.left.equalTo()(self)?.offset()(26)
            $0?.bottom.equalTo()(self)
            $0?.top.equalTo()(self)
        }
        buildConstraints(l1: l2, l2: l3)
        buildConstraints(l1: l3, l2: l4)
        buildConstraints(l1: l4, l2: l5)
        
        l6.mas_makeConstraints {
            $0?.left.equalTo()(l5.mas_right)
            $0?.bottom.equalTo()(self)
            $0?.top.equalTo()(self)
            $0?.right.equalTo()(self)
            $0?.width.equalTo()(l5)
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
