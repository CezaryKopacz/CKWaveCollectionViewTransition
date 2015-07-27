//
//  UICollectionViewExtension.swift
//  CKWaveCollectionViewTransition
//
//  Created by Salvation on 7/21/15.
//  Copyright (c) 2015 CezaryKopacz. All rights reserved.
//

import UIKit
import ObjectiveC

private var selectedIndexPathAssociationKey: UInt8 = 0
private var fromPointAssociationKey: UInt8 = 1

extension UICollectionViewController {
    
    var selectedIndexPath: NSIndexPath! {
        get {
            return objc_getAssociatedObject(self, &selectedIndexPathAssociationKey) as? NSIndexPath
        }
        set(newValue) {
            objc_setAssociatedObject(self, &selectedIndexPathAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    var fromPoint: CGPoint! {
        get {
            let value = objc_getAssociatedObject(self, &fromPointAssociationKey) as? NSValue
            return value!.CGPointValue()
        }
        set(newValue) {
            let value = NSValue(CGPoint: newValue)
            objc_setAssociatedObject(self, &fromPointAssociationKey, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
}
