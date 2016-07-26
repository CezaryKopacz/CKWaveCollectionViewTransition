//
//  NavigationControllerDelegate.swift
//  CKWaveCollectionViewTransition
//
//  Created by Salvation on 7/21/15.
//  Copyright (c) 2015 CezaryKopacz. All rights reserved.
//

import UIKit

class NavigationControllerDelegate : NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            let animator = CKWaveCollectionViewAnimator()
            animator.animationDuration = 0.7
            
            if operation != UINavigationControllerOperation.push {
                
                animator.reversed = true
            }
            
            return animator
    }
}
