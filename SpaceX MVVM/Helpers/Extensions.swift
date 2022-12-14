//
//  Extensions.swift
//  mvvm first
//
//  Created by Vlad Zavada on 12/3/22.
//

import UIKit

extension String {
    func getSizeTextOneLine(font: UIFont) -> CGSize {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let sizeText = (self as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key: Any])
            return sizeText
        }
    func getSizeText(width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.size
    }
}

extension UIFont {

    func textWidth(str: String) -> CGFloat {
        return str.size(withAttributes: [NSAttributedString.Key.font: self]).width
    }
}

extension UIFont {

    func textHeight(str: String) -> CGFloat {
        return str.size(withAttributes: [NSAttributedString.Key.font: self]).height
    }

}
