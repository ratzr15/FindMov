//
//  UISearchBar+Extension.swift
//  FindMov
//
//  Created by Rathish Kannan on 9/20/18.
//  Copyright © 2018 Rathish Kannan. All rights reserved.
//

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
