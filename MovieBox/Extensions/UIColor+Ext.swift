//
//  UIColor+Ext.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/23/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

extension UIColor {
    static let darkColor = rgb(13, 13, 13)
    static let darkRedColor = rgb(179, 0, 0)
    
    static func rgb (_ r: CGFloat, _ g: CGFloat, _ b:CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
