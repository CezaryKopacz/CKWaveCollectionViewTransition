//
//  UIViewControllerExtension.swift
//  CKWaveCollectionViewTransition
//
//  Created by Salvation on 7/21/15.
//  Copyright (c) 2015 CezaryKopacz. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func navigationBarHeight() -> CGFloat {
        
        let kNavigationBarHeight: CGFloat = 44.0
        
        var navigationBarVisible = true
        if let navigationController = self.navigationController {
            navigationBarVisible = !navigationController.navigationBarHidden
        }
        
        return navigationBarVisible ? kNavigationBarHeight : 0
    }
}
