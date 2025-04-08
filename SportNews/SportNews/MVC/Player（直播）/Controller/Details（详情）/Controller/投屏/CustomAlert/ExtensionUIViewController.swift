//
//  ExtensionUIViewController.swift
//
//
//  Created by Krishna on 21/05/19.
//  Copyright © 2019 Krishna All rights reserved.
//

import UIKit

extension UIViewController {

    static func showCustomAlertWith(VC:UIViewController, okButtonAction: (() ->())? = {}, message: String, descMsg: String, itemimage: UIImage?, videoURL: String, actions: [[String: () -> Void]]?) {
        let alertVC = CommonAlertVC.init(nibName: "CommonAlertVC", bundle: nil)
        alertVC.arrayAction = actions
        alertVC.okButtonAct = okButtonAction
        alertVC.videoURL = videoURL
        //Present
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        VC.present(alertVC, animated: true, completion: nil)
    }
}
