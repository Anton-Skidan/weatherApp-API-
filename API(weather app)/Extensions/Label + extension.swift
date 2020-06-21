//
//  UIFont + extension.swift
//  CurrentWeather
//
//  Created by Антон Скидан on 21.06.2020.
//  Copyright © 2020 Anton Skidan. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(text: String,font: UIFont? = .Helvetica17()) {
        self.init()
        
        self.text = text
        self.font = font
    }
}

