//
//  SNVideoProgressVC.swift
//  SportNews
//
//  Created by yuhua on 2021/3/30.
//

import UIKit

class SNVideoProgressVC: QMUICommonViewController {
    
    /// 当前时间
    @objc let currentTime = QMUILabel.buildPingLabel(text: "00:00", textColor: .white, font: .systemFont(ofSize: 11), alignment: .center)
    /// 总的时间
    @objc let totalTime = QMUILabel.buildPingLabel(text: " / 00:00", textColor: .white, font: .systemFont(ofSize: 11), alignment: .center)
    /// 滑竿
    @objc let slider = QMUISlider()
    /// 播放暂停
    @objc let playStop = QMUIButton()
    /// 播放回调
    @objc var playAndStopHandle: ((Bool)->Void)?
    /// 快进
    @objc var seekToTime: ((Int)->Void)?
    /// 是否在滚动进度条
    @objc var isSliderScroll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(currentTime)
        view.addSubview(totalTime)
        view.addSubview(slider)
        view.addSubview(playStop)
        slider.thumbSize = CGSize(width: 9, height: 9)
        slider.minimumTrackTintColor = Color27C5C3
        slider.thumbColor = .white
        slider.maximumTrackTintColor = .init(white: 1, alpha: 0.2)
        slider.addTarget(self, action: #selector(touchDown), for: .touchDown)
        slider.addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        slider.addTarget(self, action: #selector(touchUp), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderValueChange(slider:)), for: .valueChanged)
        playStop.imageView?.contentMode = .scaleAspectFit
        playStop.setImage(UIImage(named: "play"), for: .normal)
        playStop.setImage(UIImage(named: "pause"), for: .selected)
        playStop.addTarget(self, action: #selector(playStop(btn:)), for: .touchUpInside)
        
        playStop.mas_makeConstraints {
            $0?.left.equalTo()(view)
            $0?.top.equalTo()(view)
            $0?.bottom.equalTo()(view)
        }
        currentTime.mas_makeConstraints {
            $0?.left.equalTo()(playStop.mas_right)
            $0?.top.equalTo()(view)
            $0?.bottom.equalTo()(view)
        }
        totalTime.mas_makeConstraints {
            $0?.left.equalTo()(currentTime.mas_right)
            $0?.top.equalTo()(view)
            $0?.bottom.equalTo()(view)
        }
        slider.mas_makeConstraints {
            $0?.right.equalTo()(view)
            $0?.top.equalTo()(view)
            $0?.bottom.equalTo()(view)
            $0?.left.equalTo()(totalTime.mas_right)?.offset()(5)
        }
    }
    
    @objc func touchDown() {
        isSliderScroll = true
    }
    
    @objc func touchUp() {
        isSliderScroll = false
        self.seekToTime?(Int(slider.value))
    }
    
    @objc func playStop(btn: QMUIButton) {
        playAndStopHandle?(btn.isSelected)
    }
    
    @objc func sliderValueChange(slider: QMUISlider) {
        currentTime.text = getTimeString(time: Int(slider.value))
    }
    
    /// 刷新进度
    /// - Parameters:
    ///   - current: 当前进度
    ///   - total: 视频长度
    @objc func reloadUI(current: Int,
                        total: Int) {
        if current > total || isSliderScroll {
            return
        }
        slider.minimumValue = 0
        slider.maximumValue = Float(total)
        slider.value = Float(current)
        currentTime.text = getTimeString(time: current)
        totalTime.text = " / " + getTimeString(time: total)
    }
    
    
    /// 获取时间文字
    /// - Parameter time: 时间
    /// - Returns: 结果
    func getTimeString(time: Int) -> String {
        func get0string(value: Int) -> String {
            return value < 10 ? "0\(value)" : "\(value)"
        }
        let min = time/60
        let sec = time%60
        return get0string(value: min) + ":" + get0string(value: sec)
    }
    
    
    /// 改变播放状态
    /// - Parameter play: 是否播放
    @objc func changePlayStop(play: Bool) {
        if self.playStop.isSelected != play {
            self.playStop.isSelected = play
        }
    }
}
