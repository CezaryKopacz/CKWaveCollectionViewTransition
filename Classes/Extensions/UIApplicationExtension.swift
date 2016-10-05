//
//  UIApplicationExtension.swift
//  CKWaveCollectionViewTransition
//
//  Created by Salvation on 7/21/15.
//  Copyright (c) 2015 CezaryKopacz. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static func statusBarHeight() -> CGFloat {
        
        let kStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let statusBarVisible = !UIApplication.shared.isStatusBarHidden
        return statusBarVisible ? kStatusBarHeight : 0
    }
}
