//
//  UICollectionViewExtension.swift
//  CKWaveCollectionViewTransition
//
//  Created by Salvation on 7/21/15.
//  Copyright (c) 2015 CezaryKopacz. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func numberOfVisibleRowsAndColumn() -> (rows: Int, columns: Int) {
        
        var rows = 1
        var columns = 0
        var currentWidth: CGFloat = 0.0
        
        let visibleCells = self.visibleCells() as? Array<UICollectionViewCell>
        
        for cell in visibleCells! {
            
            if (currentWidth + cell.frame.size.width) < self.frame.size.width {
                currentWidth += cell.frame.size.width
                if rows == 1 { //we only care about first row
                    
                    columns++
                }
            } else {
                rows++
                currentWidth = cell.frame.size.width
            }
        }
        
        return (rows, columns)
    }

}
