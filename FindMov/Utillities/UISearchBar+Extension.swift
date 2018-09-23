//----------------------------------------------------------------------------------
//  File Name         :  UISearchBar+Extension.swift
//  Description       :  Extension for UISearchBar
//                       1. Manages -> Search Bar Appearance
//  Author            :  Rathish Kannan
//  E-mail            :  rathishnk@hotmail.co.in
//  Dated             :  23rd Sep 2018
//  Copyright (c) 2018 Rathish Kannan. All rights reserved.
//-----------------------------------------------------------------------------------

import Foundation
import UIKit

extension UISearchBar {
    var textField:UITextField {
        guard let txtField = self.value(forKey: "_searchField") as? UITextField else {
            assertionFailure()
            return UITextField()
        }
        return txtField
    }
    var cancelButton : UIButton? {
        if let view = self.subviews.first {
            for subView in view.subviews {
                if let cancelButton = subView as? UIButton {
                    return cancelButton
                }
            }
        }
        return nil
    }
}
