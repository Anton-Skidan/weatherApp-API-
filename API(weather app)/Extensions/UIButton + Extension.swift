//
//  UIFont + extension.swift
//  CurrentWeather
//
//  Created by Антон Скидан on 21.06.2020.
//  Copyright © 2020 Anton Skidan. All rights reserved.
//


import UIKit

extension UIButton {
    
    convenience init(title: String,
                     titleColor: UIColor,
                     font: UIFont? = .Helvetica17()) {
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
     
    }
}
    
    
