//
//  LoginChoiceCodeView.swift
//  SportNews
//
//  Created by yuhua on 2021/3/2.
//

import Foundation 

class ChoiceContentView: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @objc static let shared = ChoiceContentView()
    
    private var choice: ((Int)->Void)?
    
    private var picker = UIPickerView()
    
    private var backView: UIView!
    private var backView1: UIView!
    private var contentView: UIView!
    
    private var content: [SNCountryModel]?
    
    /// 展示一个弹出选择列表
    /// - Parameters:
    ///   - content: 列表内容
    ///   - current: 当前选中的内容，如果传，内容务必是content存在的，可不传
    ///   - choice: 被选择的回调，传回选择的序号
    @objc func show(content: [SNCountryModel], current: SNCountryModel?, choice: @escaping (Int)->Void) {
        self.choice = choice
        self.content = content
        
        backView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        backView1 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        backView1.backgroundColor = .black
        backView1.alpha = 0;
        backView.addSubview(backView1)
        
        contentView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width - 50))
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let cancel = QMUIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(Color666666, for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 16)
        cancel.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        let sure = QMUIButton(frame: CGRect(x: UIScreen.main.bounds.width-80, y: 0, width: 80, height: 40))
        sure.setTitle("确定", for: .normal)
        sure.setTitleColor(Color333333, for: .normal)
        sure.titleLabel?.font = .systemFont(ofSize: 16)
        sure.addTarget(self, action: #selector(sureChoice), for: .touchUpInside)
        contentView.addSubview(cancel)
        contentView.addSubview(sure)
        picker.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width - 50 - 40)
        picker.delegate = self
        picker.dataSource = self
        if let current = current { 
            picker.selectRow(content.firstIndex { $0.code == current.code } ?? 0, inComponent: 0, animated: false)
        }
        contentView.addSubview(picker)
        backView.addSubview(contentView)
        let KKWindow = UIApplication.shared.delegate!.window!
        KKWindow?.addSubview(backView)
        
        UIView.animate(withDuration: 0.35) {
            self.backView1.alpha = 0.7
            var frame = self.contentView.frame
            frame.origin.y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width - 50)
            self.contentView.frame = frame
        }
        
    }
    
    @objc private func sureChoice() {
        self.choice?(picker.selectedRow(inComponent: 0))
        dismiss()
        
    }
    
    /// 手动消失
    @objc func dismiss() {
        UIView.animate(withDuration: 0.35) {
            self.backView1.alpha = 0
            var frame = self.contentView.frame
            frame.origin.y = UIScreen.main.bounds.height
            self.contentView.frame = frame
        } completion: { (_) in
            self.backView.removeFromSuperview()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.content?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { 
        let str =
            String(format: "%@(%@)", self.content![row].cn, self.content![row].code)
        return str 
    }
}

