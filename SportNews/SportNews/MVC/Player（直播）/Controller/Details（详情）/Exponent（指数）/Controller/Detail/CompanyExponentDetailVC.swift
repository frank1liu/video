//
//  CompanyExponentDetailVC.swift
//  SportNews
//
//  Created by yuhua on 2021/3/10.
//

import UIKit

class CompanyExponentDetailVC: QMUICommonTableViewController {

    var type = 1
    var etype = 1
    
    var refresh: (()->Void)?
    
    var content: [[Any]]? {
        didSet {
            content?.sort {
                let t1 = ($0[0] as? Int) ?? 0
                let t2 = ($1[0] as? Int) ?? 0
                return t1 > t2
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.register(CompanyContentCell.self, forCellReuseIdentifier: "CompanyContentCell")
        tableView.mj_header = MJRefreshNormalHeader.init { [weak self] in
            self?.refresh?()
        } 
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyContentCell", for: indexPath) as! CompanyContentCell
        if let content = content?[indexPath.row],
           let t1 = content[2] as? Double,
           let t2 = content[3] as? Double,
           let t3 = content[4] as? Double,
           let time = content[1] as? String,
           let timeInt = content[0] as? Int {
            var titles: [String]
            var colors = Array(repeating: UIColor.black, count: 5)
            if time.isEmpty {
                let date = Date(timeIntervalSince1970: TimeInterval(timeInt))
                titles = ["\(t1)", "\(t2)", "\(t3)", "\(date.toString(format: "MM-dd HH:mm"))"]
            } else {
                titles = ["\(t1)", "\(t2)", "\(t3)", "\(time)"]
            }
            
            if indexPath.row != (self.content?.count ?? 0) - 1,
               let content = self.content?[indexPath.row + 1],
               let t1_1 = content[2] as? Double,
               let t2_1 = content[3] as? Double,
               let t3_1 = content[4] as? Double {
                if type == 1 {
                    colors[0] = checkColor(v1: t1, v2: t1_1)
                    colors[1] = checkColor(v1: t2, v2: t2_1)
                    colors[2] = checkColor(v1: t3, v2: t3_1)
                } else if type == 2 {
                    if etype == 1 {
                        colors[0] = checkColor(v1: t3, v2: t3_1)
                        colors[1] = checkColor(v1: t2_1, v2: t2)
                        colors[2] = checkColor(v1: t1, v2: t1_1)
                    } else if etype == 2 {
                        colors[0] = checkColor(v1: t3, v2: t3_1)
                        colors[1] = checkColor(v1: t1, v2: t1_1)
                    } else {
                        colors[0] = checkColor(v1: t1, v2: t1_1)
                        colors[1] = checkColor(v1: t2, v2: t2_1)
                        colors[2] = checkColor(v1: t3, v2: t3_1)
                    }
                }
            }
            
            if type == 1 {
                if etype == 2 {
                    titles.insert(String(format: "%0.2f", t1*t2*t3/(t1*t2+t2*t3+t1*t3)*100), at: 3)
                }
            } else if type == 2 {
                if etype == 1 {
                    let title = titles[2]
                    titles[2] = titles[0]
                    titles[0] = title
                    titles[1] = "\(-(Double(titles[1]) ?? 0))"
                } else if etype == 2 {
                    titles[1] = titles[0]
                    titles[0] = titles[2]
                    titles[2] = String(format: "%0.2f", 1/(1/t1 + 1/t3)*100)
                }
            }
            
            cell.setContent(titles: titles, colors: colors, index: indexPath.row)
        }
        return cell
    }
    
    func checkColor(v1: Double, v2: Double) -> UIColor {
        if v1 < v2 {
            return Color73D9D8
        } else if v1 > v2 {
            return ColorDA4155
        } else {
            return Color333333
        }
    }
}


class CompanyContentCell: QMUITableViewCell {
    
    let l1 = QMUILabel.buildPingLabel(text: "",
                                      textColor: .black,
                                      font: .systemFont(ofSize: 12),
                                      alignment: .center)
    let l2 = QMUILabel.buildPingLabel(text: "",
                                      textColor: .black,
                                      font: .systemFont(ofSize: 12),
                                      alignment: .center)
    let l3 = QMUILabel.buildPingLabel(text: "",
                                      textColor: .black,
                                      font: .systemFont(ofSize: 12),
                                      alignment: .center)
    let l4 = QMUILabel.buildPingLabel(text: "",
                                      textColor: .black,
                                      font: .systemFont(ofSize: 12),
                                      alignment: .center)
    let l5 = QMUILabel.buildPingLabel(text: "",
                                      textColor: .black,
                                      font: .systemFont(ofSize: 12),
                                      alignment: .center)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [l1, l2, l3, l4, l5].forEach {
            $0.backgroundColor = .clear
            contentView.addSubview($0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(titles: [String], colors: [UIColor], index: Int) {
        let width = UIScreen.main.bounds.width/CGFloat(2 + titles.count + 1)
        var arr = [QMUILabel]()
        if titles.count == 5 {
            arr = [l1, l2, l3, l4, l5]
        } else {
            l5.isHidden = true
            arr = [l1, l2, l3, l4]
        }
        contentView.backgroundColor = (index % 2 == 0) ? .white : ColorF5F5F5
        var index = 0
        arr.forEach {
            $0.frame = CGRect(x: width * CGFloat(index),
                              y: 0,
                              width: (index == titles.count-1) ? width * 2 : width,
                              height: 40)
            $0.text = titles[index]
            $0.textColor = colors[index]
            index += 1
        }
    }
}
