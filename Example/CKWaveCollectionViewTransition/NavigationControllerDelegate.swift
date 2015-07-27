//
//  NavigationControllerDelegate.swift
//  CKWaveCollectionViewTransition
//
//  Created by Salvation on 7/21/15.
//  Copyright (c) 2015 CezaryKopacz. All rights reserved.
//

import UIKit

class NavigationControllerDelegate : NSObject, UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            let animator = CKWaveCollectionViewAnimator()
            
            if operation != UINavigationControllerOperation.Push {
                
                animator.reversed = true
            }
            
            return animator
    }
}
