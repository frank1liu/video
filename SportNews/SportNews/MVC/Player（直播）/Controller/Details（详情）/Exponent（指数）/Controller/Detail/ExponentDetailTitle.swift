//
//  ExponentDetailTitle.swift
//  SportNews
//
//  Created by yuhua on 2021/3/9.
//

import UIKit

class ExponentDetailTitle: UIView {
    
    init(titles: [String]) {
        super.init(frame: .zero)
        
        let width = UIScreen.main.bounds.width/CGFloat(titles.count+2)
        titles.forEach {
            let label = QMUILabel.buildPingLabel(text: $0,
                                                 textColor: Color666666,
                                                 font: .systemFont(ofSize: 12),
                                                 alignment: .center)
            var current = width
            var x: CGFloat = 0
            if titles.firstIndex(of: $0) == 0 || titles.firstIndex(of: $0) == titles.count - 1 {
                current = width * 2
            }
            if !(titles.firstIndex(of: $0) == 0) {
                x = CGFloat((titles.firstIndex(of: $0) ?? 1) + 1) * width
            }
            label.frame = CGRect(x: x, y: 0, width: current, height: 30)
            addSubview(label)
        }
        
        backgroundColor = ColorF5F5F5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
