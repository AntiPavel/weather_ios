//
//  UIViewController+Ext.swift
//  WeatherApp
//
//  Created by paul on 16/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    func show(error text: String) {
        let alert = UIAlertController(title: nil,
                                      message: text,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.destructive,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
