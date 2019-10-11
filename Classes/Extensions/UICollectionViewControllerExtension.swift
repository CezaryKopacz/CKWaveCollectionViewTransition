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
    
    var selectedIndexPath: IndexPath? {
        get { return objc_getAssociatedObject(self, &selectedIndexPathAssociationKey) as? IndexPath }
        set (newValue) { objc_setAssociatedObject(self, &selectedIndexPathAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    var fromPoint: CGPoint? {
        get {
            return (objc_getAssociatedObject(self, &fromPointAssociationKey) as? NSValue)?.cgPointValue
        }
        set (newValue) {
            guard let newValue = newValue else { return }
            let nsValue = NSValue(cgPoint: newValue)
            objc_setAssociatedObject(self, &fromPointAssociationKey, nsValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
