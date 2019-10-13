//
//  UIViewControllerExtension.swift
//  CKWaveCollectionViewTransition
//
//  Created by Salvation on 7/21/15.
//  Copyright (c) 2015 CezaryKopacz. All rights reserved.
//

import UIKit

extension UIViewController {
    var navigationBarHeight: CGFloat {
        guard let navigationController = navigationController else { return CGFloat.zero }
        let navigationBarHeight = navigationController.navigationBar.frame.height
        let navigationBarVisible =  !navigationController.isNavigationBarHidden
        return navigationBarVisible ? navigationBarHeight : 0
    }
}
