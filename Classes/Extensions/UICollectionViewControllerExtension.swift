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
    
    var selectedIndexPath: IndexPath! {
        get {
            return objc_getAssociatedObject(self, &selectedIndexPathAssociationKey) as? IndexPath
        }
        set(newValue) {
            objc_setAssociatedObject(self, &selectedIndexPathAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var fromPoint: CGPoint! {
        get {
            let value = objc_getAssociatedObject(self, &fromPointAssociationKey) as? NSValue
            return value!.cgPointValue
        }
        set(newValue) {
            let value = NSValue(cgPoint: newValue)
            objc_setAssociatedObject(self, &fromPointAssociationKey, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
