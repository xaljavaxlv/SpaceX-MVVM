//
//  GlobalFunctions.swift
//  mvvm first
//
//  Created by Vlad Zavada on 12/3/22.
//

import UIKit

func getHeightForLabel(label: UILabel) -> CGFloat {
    
    let width = label.frame.size.width
    let font =  label.font!
    var text = label.text
    if text == nil {
        text = ""
    }
    let sizeForLabel = text!.getSizeText(width: width, font: font)
    let height = sizeForLabel.height
    return height
    
}


func updateLabelWidth(label: UILabel) {
    guard let text = label.text else { return }
    let width = label.font.textWidth(str: text)
    label.frame.size.width = width
}
