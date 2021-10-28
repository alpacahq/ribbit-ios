//
//  UILabel+Ext.swift
//  Ribbit
//
//  Created by Ahsan Ali on 24/03/2021.
//

import UIKit

extension UILabel {
    func strikeThrough(_ isStrikeThrough: Bool) {
        if isStrikeThrough {
            if let lblText = self.text {
                let attributeString = NSMutableAttributedString(string: lblText)
                self.attributedText = attributeString
            }
        } else {
            if let attributedStringText = self.attributedText {
                let txt = attributedStringText.string
                self.attributedText = nil
                self.text = txt
                return
            }
        }
    }
}
