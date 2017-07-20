//
//  Extentions.swift
//  Smashtag
//
//  Created by 劉洧熏 on 2017/7/19.
//  Copyright © 2017年 劉洧熏. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func makeSimpleAlert(title: String = "", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIView {
    func setConstraintsToBoundary(from subview: UIView, To superView: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
    }
}

extension UINavigationController {
    var isNavigationTransparent: Bool {
        get {
            return (self.navigationBar.shadowImage == nil) ? false: true
        }

        set {
            if self.navigationBar.shadowImage == nil {
                self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                self.navigationBar.shadowImage = UIImage()
                self.navigationBar.isTranslucent = true
                self.view.backgroundColor = UIColor.clear
            } else {
                self.navigationBar.shadowImage = nil
                self.navigationBar.isTranslucent = false
            }
        }
    }
}
