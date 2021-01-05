//
//  UIView+Ext.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/3/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import SkeletonView

extension UIView {
    func showCustomAnimatedSkeleton () {
        let gradient = SkeletonGradient(baseColor: UIColor.wetAsphalt)
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        self.isSkeletonable = true
        self.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
    }
}
