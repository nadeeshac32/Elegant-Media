//
//  NCUIMaker.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit

var screenWidth: CGFloat { return UIScreen.main.bounds.width }

struct NCUIMaker {
    static func makeLabel(text: String? = nil,
                          font: UIFont = UIFont.systemFont(ofSize: 15),
                          color: UIColor = .black,
                          numberOfLines: Int = 1,
                          alignment: NSTextAlignment = .left) -> UILabel {
        
        let label                   = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                  = font
        label.textColor             = color
        label.text                  = text
        label.numberOfLines         = numberOfLines
        label.textAlignment         = alignment
        return label
    }
    
    static func makeImageView(image: UIImage? = nil,
                              contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImageView {
        
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode              = contentMode
        iv.clipsToBounds            = true
        return iv
    }
    
    static func makeLine(color: UIColor, height: CGFloat) -> UIView {
        let line                    = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: height))
        line.backgroundColor        = color
        return line
    }
    
    static func makeButtonWith(imageName: String = "icon_back") -> UIButton {
        let button                                          = UIButton(type: .custom)
        button.frame                                        = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.clipsToBounds                                = true
        button.backgroundColor                              = UIColor.clear
        button.contentVerticalAlignment                     = .center
        let buttonImage                                     = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.tintColor                                    = UIColor.white
        
        return button
    }
    
    static func makeButtonWith(text: String, width: CGFloat? = 120) -> UIButton {
        let button                                          = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints    = true
        button.frame                                        = CGRect(x: 0, y: 0, width: width!, height: 44)
        button.clipsToBounds                                = true
        button.backgroundColor                              = UIColor.clear
        button.contentVerticalAlignment                     = .center
        button.setTitle(text, for: .normal)
        return button
    }
    
    static func makeSwitch() -> UISwitch {
        let switchTemp                                      = UISwitch(frame:CGRect(x: 0, y: 0, width: 20, height: 20))
        switchTemp.onTintColor                              = UIColor(hexString: "000000")?.withAlphaComponent(0.3)
        switchTemp.setOn(false, animated: false)
        return switchTemp
    }
    
}

