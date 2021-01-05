//
//  UIScollView+Ext.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/2/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

extension UIScrollView {
    func fitSizeOfContent() {
        let sumHeight = self.subviews.map({$0.frame.size.height}).reduce(0, {x, y in x + y})
        self.contentSize = CGSize(width: self.frame.width, height: sumHeight)
    }
}

