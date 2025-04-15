//
//  LiveListCalendarVC.swift
//  SportNews
//
//  Created by yuhua on 2021/3/15.
//

import UIKit

struct DayModel {
    let dayString: String
}


let IPHONE_X = isNotchScreen()

//导航栏高度
let KNavHeight = CGFloat((IPHONE_X ? 88.0 : 64.0))

//用来判断是不是全面屏
func isNotchScreen() -> Bool {
    
    if UIDevice.current.userInterfaceIdiom == .pad {
        return false
    }
    let size = UIScreen.main.bounds.size
    let notchValue:Int = Int(size.width / size.height * 100)
    if 216 == notchValue || 46 == notchValue {
        return true
    }
    
    return isFullScreen()
}

//用来判断是不是全面屏
func isFullScreen() -> Bool {
    if #available(iOS 11, *) {
          guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
              return false
          }
          if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
              print(unwrapedWindow.safeAreaInsets)
              return true
          }
    }
    return false
}


class LiveListCalendarVC: QMUICommonViewController {
    /// 保持vc
    static var handle: LiveListCalendarVC?
    /// 顶部
    let top = CalendarTop()
    /// 周
    let week = CalendarWeek()
    /// 日历内容
    let content = CalendarContent()
    /// 日历日期来源，不设置，默认为当前
    // var date = Date()

    var date: Date = {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents(in: TimeZone(identifier: "Asia/Shanghai")!, from: Date())
        // 用台北時區組合成一個新的 Date
        if let taipeiDate = calendar.date(from: components) {
            print("上海時區的 Date: \(taipeiDate)")
            return taipeiDate
        }
        return Date()
    }()
    /// 选择日期，不设置，则默认为当前
    var choice: Date?
    /// 比赛数目数据，外部传入，字典，格式：["2021-02-01":"20","2021-02-02":"22"]
    var dayNumberData: [String: String]? {
        didSet {
            self.content.dayNumberData = dayNumberData
            self.content.collection?.reloadData()
        }
    }
    /// 选择日期后的回调，会把日期字符串传递出来
    var choiceDate: ((String)->Void)?
    /// 日历系统
    let calendar = Calendar.current
    /// 日历数据缓存
    static var dayContent: [String: [DayModel]]?
    /// 连续日期
    static var dayContentList: [String]?
    /// 背景遮罩view
    let backView = UIView(frame: UIScreen.main.bounds)
    let tapView = UIView(frame: UIScreen.main.bounds)
    
    /// 弹出日历选择view
    /// - Parameters:
    ///   - date: 锚点日期，默认当天，用于确定日历显示范围
    ///   - choiceDate: 选择日期，不设置，则默认为锚点日期，该日期在日历高亮显示
    ///   - dayNumberDate: 比赛数目数据，必须传入，用于在日期下发显示场数，字典，格式：["2021-02-01":"20","2021-02-02":"22"]
    ///   - choice: 选择日期后的回调，会把日期传回
    @objc static func show(date: Date = Date(),
                           choiceDate: Date? = nil,
                           dayNumberDate: [String: String],
                           choice: @escaping (String)->Void) {
        let vc = LiveListCalendarVC()
        vc.date = date
        if let choiceDate = choiceDate {
            vc.choice = choiceDate
        } else {
            vc.choice = date
        }
        vc.dayNumberData = dayNumberDate
        vc.choiceDate = choice
        vc.show()
    }
    /// 弹出日历选择
    func show() {
        LiveListCalendarVC.handle = self
        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        tapView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        backView.addSubview(tapView)
        backView.addSubview(view)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        tapView.addGestureRecognizer(tap)
        let window = UIApplication.shared.delegate!.window!
        window?.addSubview(backView)
    }
    /// 外部手动消失日历
    @objc static func dismissVC() {
        LiveListCalendarVC.handle?.dismissVC()
    }
    /// 消失日历选择
    @objc private func dismissVC() {
        backView.removeFromSuperview()
        LiveListCalendarVC.handle = nil
    }
    deinit {
        print("\(type(of: self))销毁了")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if choice == nil {
            choice = date
        }
        view.frame = CGRect(x: 10, y: KNavHeight+85, width: UIScreen.main.bounds.width-20, height: 422)
        view.layer.cornerRadius = 12
        view.addSubview(top)
        view.addSubview(week)
        view.addSubview(content)
        content.randomBackgroundColor()
        top.mas_makeConstraints {
            $0?.left.equalTo()(view)
            $0?.right.equalTo()(view)
            $0?.top.equalTo()(view)
            $0?.height.mas_equalTo()(60)
        }
        week.mas_makeConstraints {
            $0?.left.equalTo()(view)
            $0?.right.equalTo()(view)
            $0?.top.equalTo()(top.mas_bottom)
            $0?.height.mas_equalTo()(30)
        }
        content.mas_makeConstraints {
            $0?.left.equalTo()(view)?.offset()
            $0?.right.equalTo()(view)?.offset()
            $0?.top.equalTo()(week.mas_bottom)
            $0?.height.mas_equalTo()(320)
        }
        view.layoutIfNeeded()
        content.buildCollection()
        top.jumpLeft = { [weak self] in
            if let index = self?.content.currentItemIndex(),
               index <= 2,
               index > 0{
                self?.reloadViewContent(current: index - 1)
            }
        }
        top.jumpRight = { [weak self] in
            if let index = self?.content.currentItemIndex(),
               index >= 0,
               index < 2{
                self?.reloadViewContent(current: index + 1)
            }
        }
        top.jumpToday = { [weak self] in
            self?.choice = self?.date
            self?.reloadViewContent(current: 1)
            if let today = self?.date.toString(format: "yyyy-MM-dd") {
                self?.choiceDate?(today)
            }
        }
        content.scrollEnd = { [weak self] in
            if let current = self?.content.currentItemIndex() {
                self?.reloadViewContent(current: current)
            }
        }
        content.choiceDay = { [weak self] day in
            self?.choice = day.toDate(format: "yyyy-MM-dd")
            if let index = self?.content.currentItemIndex() {
                self?.reloadViewContent(current: index)
            }
            self?.choiceDate?(day)
        }
    }
    /// 首次进入，刷新数据
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTop(current: 1)
        reloadContent()
        reloadViewWithChoice()
    }
    /// 手动指定刷新数据
    func reloadViewContent(current: Int) {
        content.currentYearMonth = getYearMonth(current: current)
        content.currentChoice = choice?.toString(format: "yyyy-MM-dd")
        content.scrollToRow(row: current, animation: true)
        reloadTop(current: current)
        content.collection.reloadData()
    }
    /// 刷新顶部
    func reloadTop(current: Int) {
        if current == 1 {
            top.current.text = date.toString(format: "yyyy年M月")
            top.left.isSelected = true
            top.right.isSelected = true
        } else if current == 0 {
            top.current.text = calendar.date(byAdding: .month, value: -1, to: date)?.toString(format: "yyyy年M月")
            top.left.isSelected = false
            top.right.isSelected = true
        } else {
            top.current.text = calendar.date(byAdding: .month, value: 1, to: date)?.toString(format: "yyyy年M月")
            top.left.isSelected = true
            top.right.isSelected = false
        }
    }
    /// 获得年月信息
    func getYearMonth(current: Int) -> String? {
        if current == 1 {
            return date.toString(format: "yyyy-MM")
        } else if current == 0 {
            return calendar.date(byAdding: .month, value: -1, to: date)?.toString(format: "yyyy-MM")
        } else {
            return calendar.date(byAdding: .month, value: 1, to: date)?.toString(format: "yyyy-MM")
        }
    }
    /// 获得日历内容
    func reloadContent() {
        let current = date.toString(format: "yyyy-MM-dd")
        if LiveListCalendarVC.dayContent?.keys.first == current {
            print("已经构建了日历内容，无需再次构建！")
            content.currentYearMonth = date.toString(format: "yyyy-MM")
            content.currentChoice = choice?.toString(format: "yyyy-MM-dd")
            content.contents = LiveListCalendarVC.dayContent![current]
            return
        } else {
            LiveListCalendarVC.dayContent = [current: []];
        }
        if let upMonthCurrentDay = calendar.date(byAdding: .month, value: -1, to: date),
           let downMonthCurrentDay = calendar.date(byAdding: .month, value: 1, to: date) {
            let content = getDayContentFrom(date: upMonthCurrentDay)
                + getDayContentFrom(date: date)
                + getDayContentFrom(date: downMonthCurrentDay)
            LiveListCalendarVC.dayContent?[current] = content
            self.content.currentYearMonth = date.toString(format: "yyyy-MM")
            self.content.currentChoice = choice?.toString(format: "yyyy-MM-dd")
            self.content.contents = content
        }
    }
    /// 根据外部传入的choice，定位显示内容
    func reloadViewWithChoice() {
        if let choice = self.choice?.toString(format: "yyyy-MM") {
            let current = date.toString(format: "yyyy-MM")
            if choice < current {
                reloadViewContent(current: 0)
            } else if choice > current {
                reloadViewContent(current: 2)
            }
        }
    }
    /// 获得指定日期当月日历内容
    func getDayContentFrom(date: Date) -> [DayModel] {
        var contents = [DayModel]()
        let components = calendar.dateComponents(in: TimeZone.current, from: date)
        if let weekday = components.weekday,
           let weekNumber = components.weekOfMonth {
            let up = weekday - 1 + (weekNumber - 1) * 7
            if let first = calendar.date(byAdding: .day, value: -up, to: date) {
                let yearMonth = date.toString(format: "yyyy-MM")
                (0...41).forEach {
                    if let nextDay = calendar.date(byAdding: .day, value: $0, to: first) {
                        let day = nextDay.toString(format: "yyyy-MM-dd")
                        if day.contains(yearMonth) {
                            contents.append(DayModel(dayString: day))
                        } else {
                            contents.append(DayModel(dayString: ""))
                        }
                    }
                }
            }
        }
        return contents
    }
    /// 获得连续的日期数据
    @objc static func getDayContent() -> [String] {
        if let list = LiveListCalendarVC.dayContentList {
            print("已经构建了连续日历内容，无需再次构建！")
            return list
        } else {
            var result = [String]()
            let calendar = Calendar.current
            let date = Date()
            let up = calendar.date(byAdding: .month, value: -1, to: date) ?? date
            let down = calendar.date(byAdding: .month, value: 1, to: date) ?? date
            let upNumbers = calendar.range(of: .day, in: .month, for: up)?.count ?? 0
            let currentNumber = calendar.range(of: .day, in: .month, for: date)?.count ?? 0
            let downNumber = calendar.range(of: .day, in: .month, for: down)?.count ?? 0
            let components = calendar.dateComponents(in: TimeZone.current, from: up)
            if let weekday = components.weekday,
               let weekNumber = components.weekOfMonth {
                let upNumber = weekday - 2 + (weekNumber - 1) * 7
                let first = calendar.date(byAdding: .day, value: -upNumber, to: up) ?? date
                (0 ..< upNumbers+downNumber+currentNumber).forEach {
                    result.append(calendar.date(byAdding: .day, value: $0, to: first)?.toString(format: "yyyy-MM-dd") ?? "")
                }
            }
            LiveListCalendarVC.dayContentList = result
            return result
        }
    }
    
    @objc static func getCurrentString() -> String {
        // return Date().toString(format: "yyyy-MM-dd")
        let date = Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai") // 這裡可以改成其他亞洲時區

        let taipeiTime = formatter.string(from: date)
        // print("台北時間：\(taipeiTime)")
        return taipeiTime;
    }
}

class CalendarTop: UIView {
    /// 顶部今天按钮
    let today = QMUIButton.buildPingButton(text: "今天")
    /// 顶部标题
    let current = QMUILabel.buildPingLabel(text: "", textColor: Color333333, font: .systemFont(ofSize: 17), alignment: .center)
    /// 上一月
    let left = QMUIButton()
    /// 下一月
    let right = QMUIButton()
    /// 上一月回调
    var jumpLeft: (()->Void)?
    /// 下一月回调
    var jumpRight: (()->Void)?
    /// 选择今天回调
    var jumpToday: (()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(today)
        today.setTitleColor(Color27C5C3, for: .normal)
        today.titleLabel?.font = .systemFont(ofSize: 13)
        today.mas_makeConstraints {
            $0?.bottom.equalTo()(self)
            $0?.right.equalTo()(self)?.offset()(-10)
            $0?.top.equalTo()(self)
            $0?.width.mas_equalTo()(40)
        }
        addSubview(current)
        current.mas_makeConstraints {
            $0?.center.equalTo()(self)
            $0?.width.equalTo()(140)
        }
        left.setImage(UIImage(named: "leftArrow"), for: .normal)
        right.setImage(UIImage(named: "rightArrow"), for: .normal)
        left.setImage(UIImage(named: "leftArrow")!.qmui_image(withTintColor: Color27C5C3), for: .selected)
        right.setImage(UIImage(named: "rightArrow")!.qmui_image(withTintColor: Color27C5C3), for: .selected)
        addSubview(left)
        addSubview(right)
        left.mas_makeConstraints {
            $0?.bottom.equalTo()(self)
            $0?.right.equalTo()(current.mas_left)
            $0?.top.equalTo()(self)
            $0?.width.mas_equalTo()(20)
        }
        right.mas_makeConstraints {
            $0?.bottom.equalTo()(self)
            $0?.left.equalTo()(current.mas_right)
            $0?.top.equalTo()(self)
            $0?.width.mas_equalTo()(20)
        }
        left.addTarget(self, action: #selector(jumpLeftAction), for: .touchUpInside)
        right.addTarget(self, action: #selector(jumpRightAction), for: .touchUpInside)
        today.addTarget(self, action: #selector(jumpTodayAction), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func jumpLeftAction() {
        jumpLeft?()
    }
    @objc func jumpRightAction() {
        jumpRight?()
    }
    @objc func jumpTodayAction() {
        jumpToday?()
    }
}

class CalendarWeek: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        var index = 0
        var up: QMUILabel?
        ["日", "一", "二", "三", "四", "五", "六"].forEach {
            let label = QMUILabel.buildPingLabel(text: $0, textColor: Color333333, font: .systemFont(ofSize: 14), alignment: .center)
            addSubview(label)
            if index == 0 {
                label.mas_makeConstraints {
                    $0?.bottom.equalTo()(self)
                    $0?.left.equalTo()(self)
                    $0?.top.equalTo()(self)
                }
            } else if index == 6 {
                label.mas_makeConstraints {
                    $0?.bottom.equalTo()(self)
                    $0?.right.equalTo()(self)
                    $0?.top.equalTo()(self)
                    $0?.left.equalTo()(up!.mas_right)
                    $0?.width.equalTo()(up)
                }
            } else {
                label.mas_makeConstraints {
                    $0?.bottom.equalTo()(self)
                    $0?.top.equalTo()(self)
                    $0?.left.equalTo()(up!.mas_right)
                    $0?.width.equalTo()(up)
                }
            }
            up = label
            index += 1
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CalendarContent: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    var collection: UICollectionView!
    /// 当前显示年月信息，用来判断字体颜色
    var currentYearMonth: String?
    /// 当前选择日期
    var currentChoice: String?
    /// 数据
    var contents: [DayModel]? {
        didSet {
            collection.reloadData()
        }
    }
    /// 比赛数组数据
    var dayNumberData: [String: String]?
    /// 选择日期回调
    var choiceDay: ((String)->Void)?
    /// 列表滚动结束回调
    var scrollEnd: (()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 当前显示下标
    func currentItemIndex() -> Int {
        for cell in collection.visibleCells {
            let indexPath = collection.indexPath(for: cell)
            if let row = indexPath?.row {
                return row
            }
        }
        return -1
    }
    /// 构建
    func buildCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: frame.width, height: frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.bounces = false
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(CalendarCollectionCell.self, forCellWithReuseIdentifier: "CalendarCell0")
        collection.register(CalendarCollectionCell.self, forCellWithReuseIdentifier: "CalendarCell1")
        collection.register(CalendarCollectionCell.self, forCellWithReuseIdentifier: "CalendarCell2")
        addSubview(collection)
        collection.mas_makeConstraints {
            $0?.edges.equalTo()(self)
        }
        layoutIfNeeded()
        scrollToRow(row: 1)
    }
    /// 滚动
    func scrollToRow(row: Int, animation: Bool = false) {
        collection.scrollToItem(at: IndexPath(item: row, section: 0), at: .centeredHorizontally, animated: animation)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell\(indexPath.row)", for: indexPath) as! CalendarCollectionCell
        if let contents = contents {
            cell.reloadContent(content: Array(contents[42*indexPath.row...(41+42*indexPath.row)]), current: currentYearMonth ?? "none", choice: currentChoice ?? "none", numberData: dayNumberData ?? [:])
        }
        cell.tap = { [weak self] row in
            if let cellRow = self?.currentItemIndex() {
                let itemIndex = cellRow * 42 + row
                if let item = self?.contents?[itemIndex],
                   let count = self?.dayNumberData?[item.dayString],
                   !count.isEmpty,
                   count != "0" {
                    self?.choiceDay?(item.dayString)
                }
            }
        }
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !scrollView.isTracking &&
            !scrollView.isDragging &&
            !scrollView.isDecelerating {
            scrollEnd?()
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !scrollView.isTracking &&
            !scrollView.isDragging &&
            !scrollView.isDecelerating {
            scrollEnd?()
        }
    }
}
class CalendarCollectionCell: UICollectionViewCell {
    var tap: ((Int)->Void)?
    var isReload = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let width = frame.size.width/7
        let height = frame.size.height/6
        var up: QMUIButton?
        (0...41).forEach { item in
            let button = QMUIButton()
            button.addTarget(self, action: #selector(buttonTap(button:)), for: .touchUpInside)
            button.tag = item + 10;
            addSubview(button)
            button.titleLabel?.numberOfLines = 2
            button.titleLabel?.textAlignment = .center
            if item % 7 == 0 {
                button.mas_makeConstraints {
                    $0?.left.equalTo()(self)
                    $0?.top.equalTo()(self)?.offset()(CGFloat(item / 7) * height)
                    $0?.size.equalTo()(CGSize(width: width, height: height))
                }
            } else {
                button.mas_makeConstraints {
                    $0?.left.equalTo()(up!.mas_right)
                    $0?.top.equalTo()(self)?.offset()(CGFloat(item / 7) * height)
                    $0?.size.equalTo()(CGSize(width: width, height: height))
                }
            }
            up = button
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func buttonTap(button: QMUIButton) {
        tap?(button.tag - 10)
    }
    func reloadContent(content: [DayModel], current: String, choice: String, numberData: [String: String]) {
        let day = Date().toString(format: "yyyy-MM-dd")
        if !isReload {
            isReload = true
            (0...41).forEach {
                if let button = viewWithTag($0 + 10) as? QMUIButton,
                   let number = content[$0].dayString.components(separatedBy: "-").last?.removeFirt0() {
                    if !number.isEmpty {
                        var title: NSMutableAttributedString!;
                        let count = numberData[content[$0].dayString]
                        if let count = count, !count.isEmpty, count != "0" {
                            if content[$0].dayString == day {
                                title = NSMutableAttributedString(string: "今天", attributes: [NSAttributedString.Key.foregroundColor: Color333333, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
                            } else {
                                title = NSMutableAttributedString(string: number, attributes: [NSAttributedString.Key.foregroundColor: Color333333, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
                            }
                        } else {
                            if content[$0].dayString == day {
                                title = NSMutableAttributedString(string: "今天", attributes: [NSAttributedString.Key.foregroundColor: Color979797, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
                            } else {
                                title = NSMutableAttributedString(string: number, attributes: [NSAttributedString.Key.foregroundColor: Color979797, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
                            }
                        }
                        title.append(NSAttributedString(string: count == nil ? "" : "\n\(count!)场", attributes: [NSAttributedString.Key.foregroundColor: Color979797, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)]))
                        button.setAttributedTitle(title, for: .normal)
                        title = NSMutableAttributedString(string: number, attributes: [NSAttributedString.Key.foregroundColor: Color27C5C3, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
                        if content[$0].dayString == day {
                            title = NSMutableAttributedString(string: "今天", attributes: [NSAttributedString.Key.foregroundColor: Color27C5C3, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
                        }
                        title.append(NSAttributedString(string: count == nil ? "" : "\n\(count!)场", attributes: [NSAttributedString.Key.foregroundColor: Color27C5C3, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)]))
                        button.setBackgroundImage(UIImage.qmui_image(with: ColorEDFCF8, size: CGSize(width: 44, height: 44), cornerRadius: 22), for: .selected)
                        button.setAttributedTitle(title, for: .selected)
                        button.isSelected = content[$0].dayString == choice
                    }
                }
            }
        }
    }
}
