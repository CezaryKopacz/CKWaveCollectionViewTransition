//
//  CKWaveCollectionViewAnimator.swift
//  CKWaveCollectionViewTransition
//
//  Created by Salvation on 7/13/15.
//  salvation.sv@gmail.com
//  cezarykopacz.github.io
//  Copyright (c) 2015 CezaryKopacz. All rights reserved.
//

import UIKit

class CKWaveCollectionViewAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    internal var reversed: Bool = false
    
    internal let animationDuration: Double! = 1.0
    internal let kCellAnimSmallDelta: Double! = 0.01
    internal let kCellAnimBigDelta: Double! = 0.03
    
    
    private let kTopCellLayerZIndex: CGFloat! = 1000.0
    private let kDeltaBetweenCellLayers: Int! = 2
    
    //MARK :- UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        var destinationCollectionViewController: UICollectionViewController!
        var sourceCollectionViewController: UICollectionViewController!
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        //let container = transitionContext.containerView()
        
        guard let container = transitionContext.containerView() else {
            assertionFailure("containerView is nil")
            return
        }
        
        container.backgroundColor = UIColor.clearColor()

        destinationCollectionViewController = toViewController as? UICollectionViewController
        assert(destinationCollectionViewController != nil, "Destination view controller is not a UICollectionViewController subclass!")
        
        sourceCollectionViewController = fromViewController as? UICollectionViewController
        assert(sourceCollectionViewController != nil, "Source view controller is not a UICollectionViewController subclass!")
        
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        
        if self.reversed == false {
        
            container.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
            //copy colors
            let destinationViewControllerViewBackgroundColor = toViewController.view.backgroundColor
            let destinationCollectionViewBackgroundColor = destinationCollectionViewController.collectionView?.backgroundColor

            self.collectionViewTransition(toViewController, transitionContext: transitionContext, destinationCollectionViewController: destinationCollectionViewController, sourceCollectionViewController: sourceCollectionViewController, destinationViewControllerViewBackgroundColor: destinationViewControllerViewBackgroundColor, destinationCollectionViewBackgroundColor: destinationCollectionViewBackgroundColor)
        } else {
        
            container.insertSubview(toViewController.view, belowSubview: fromViewController.view)

            self.reversedCollectionViewTransition(toViewController, fromViewController: fromViewController, transitionContext: transitionContext, sourceCollectionViewController: sourceCollectionViewController, destinationCollectionViewController: destinationCollectionViewController)
        }
    }

    //MARK :- helper private methods
    
    private func collectionViewTransition(toViewController: UIViewController, transitionContext: UIViewControllerContextTransitioning, destinationCollectionViewController: UICollectionViewController, sourceCollectionViewController: UICollectionViewController, destinationViewControllerViewBackgroundColor: UIColor?, destinationCollectionViewBackgroundColor: UIColor?) {
        
        setupDestinationViewController(toViewController, context: transitionContext)
        
        UIView.animateWithDuration(0, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            
            //fake empty animation
            }) { (finished) -> Void in
                
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    
                    toViewController.view.alpha = 1.0
                })
                
                UIView.animateWithDuration(self.animationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    
                    toViewController.view.backgroundColor = destinationViewControllerViewBackgroundColor
                    
                    destinationCollectionViewController.collectionView?.backgroundColor = destinationCollectionViewBackgroundColor
                    
                    }) { (finished) -> Void in
                        
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                }
                
                self.addAnimationsToDestinationCollectionView(destinationCollectionViewController, sourceCollectionViewController: sourceCollectionViewController, toViewController: toViewController)
        }
    }
    
    private func reversedCollectionViewTransition(toViewController: UIViewController, fromViewController: UIViewController, transitionContext: UIViewControllerContextTransitioning, sourceCollectionViewController: UICollectionViewController, destinationCollectionViewController: UICollectionViewController)
    {
        UIView.animateWithDuration(0, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            
            //fake empty animation
            }) { (finished) -> Void in
                
                UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
                    
                    fromViewController.view.backgroundColor = UIColor.clearColor()
                    sourceCollectionViewController.collectionView!.backgroundColor = UIColor.clearColor()
                    
                    }, completion: { (finished) -> Void in
                        
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
                
                let destinationPoint = self.calculateDestinationAnimationPoint(sourceCollectionViewController, toViewController: toViewController)
                
                self.setNewFrameToCells(destinationCollectionViewController)
                self.enumerateVisibleCellsAndAddAnimations(destinationPoint, sourceCollectionViewController: sourceCollectionViewController, destinationCollectionViewController: destinationCollectionViewController)
        }
    }
    
    private func calculateSourceAnimationPoint(selectedCellCenter: CGPoint, sourceCollectionViewController: UICollectionViewController, destinationCollectionViewController: UICollectionViewController) -> CGPoint {
        
        let animateFromPoint = sourceCollectionViewController.collectionView?.convertPoint(selectedCellCenter, toView: sourceCollectionViewController.view)
        return CGPointMake(animateFromPoint!.x,
                           animateFromPoint!.y - UIApplication.statusBarHeight() - destinationCollectionViewController.navigationBarHeight())
    }

    private func addAnimationsToDestinationCollectionView(destinationCollectionViewController: UICollectionViewController, sourceCollectionViewController: UICollectionViewController, toViewController: UIViewController) {
        
        let indexPaths: NSArray = sourceCollectionViewController.collectionView!.indexPathsForSelectedItems()!
        let selectedCellIndex: NSIndexPath = indexPaths.firstObject as! NSIndexPath
        let selectedCell = sourceCollectionViewController.collectionView!.cellForItemAtIndexPath(selectedCellIndex)!
        
        //copy selected cell background color
        let selectedCellBackgroundColor = selectedCell.backgroundColor
        
        let sourceAnimationPoint = self.calculateSourceAnimationPoint(selectedCell.center, sourceCollectionViewController: sourceCollectionViewController, destinationCollectionViewController: destinationCollectionViewController)
        
        destinationCollectionViewController.fromPoint = sourceAnimationPoint
        
        let rowsAndColumns = destinationCollectionViewController.collectionView!.numberOfVisibleRowsAndColumn()
        
        if let indexPathsForVisibleCells = destinationCollectionViewController.collectionView?.indexPathsForVisibleItems() {

            let indexPaths = indexPathsForVisibleCells.sort({ $0.row < $1.row })
        
            for (_, index) in indexPaths.enumerate() {
            
                if let cell = destinationCollectionViewController.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow: index.row, inSection: index.section)) {
                    
                    self.addCellAnimations(sourceAnimationPoint, sourceCollectionViewController: sourceCollectionViewController, destinationCollectionViewController: destinationCollectionViewController, cell: cell, fromCellColor: selectedCellBackgroundColor!, cellIndexPath: index, rowsAndColumns: rowsAndColumns)
                }
            }

        }
    }
    
    private func addCellAnimations(animateFromPoint: CGPoint, sourceCollectionViewController: UICollectionViewController, destinationCollectionViewController: UICollectionViewController, cell: UICollectionViewCell, fromCellColor: UIColor, cellIndexPath: NSIndexPath, rowsAndColumns: (rows: Int, columns: Int)) {
        
        //copy cell color
        let cellOriginalColor = cell.backgroundColor
        
        //temporary change cell color to selected cell background color
        cell.backgroundColor = fromCellColor
        
        let source = sourceCollectionViewController.collectionView
        let destination = destinationCollectionViewController.collectionView
        
        if let fromFlowLayout = source?.collectionViewLayout as? UICollectionViewFlowLayout,
            toFlowLayout = destination?.collectionViewLayout as? UICollectionViewFlowLayout,
            cellLayoutAttributes = destination?.layoutAttributesForItemAtIndexPath(cellIndexPath) {

            cell.frame.size = fromFlowLayout.itemSize
            cell.center = animateFromPoint
            cell.alpha = 1.0
            cell.layer.zPosition = kTopCellLayerZIndex - CGFloat(cellIndexPath.row*self.kDeltaBetweenCellLayers)
        
            UIView.animateKeyframesWithDuration(1.0, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: { () -> Void in
            
                let relativeStartTime = (self.kCellAnimBigDelta*Double(cellIndexPath.row % rowsAndColumns.columns))

                var relativeDuration = self.animationDuration - (self.kCellAnimSmallDelta * Double(cellIndexPath.row))
            
                if (relativeStartTime + relativeDuration) > self.animationDuration {
                    relativeDuration = self.animationDuration - relativeStartTime
                }
            
                UIView.addKeyframeWithRelativeStartTime(0.0 + (self.kCellAnimBigDelta*Double(cellIndexPath.row % rowsAndColumns.columns)), relativeDuration: relativeDuration, animations: { () -> Void in
                
                    cell.backgroundColor = cellOriginalColor
                })
            
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.1, animations: { () -> Void in
                
                    cell.alpha = 1.0
                })
            
                UIView.addKeyframeWithRelativeStartTime(0.0 + (self.kCellAnimBigDelta*Double(cellIndexPath.row % rowsAndColumns.columns)), relativeDuration: relativeDuration, animations: { () -> Void in
                
                    cell.frame = self.centerPointWithSizeToFrame(cellLayoutAttributes.center, size: toFlowLayout.itemSize)
                })
            
                }, completion: { (finished) -> Void in
                
                    cell.layer.zPosition = 0
            })
        }
    }
    
    private func calculateDestinationAnimationPoint(sourceCollectionViewController: UICollectionViewController, toViewController: UIViewController) -> CGPoint {
    
        let animateToPoint = sourceCollectionViewController.fromPoint
        let offset = sourceCollectionViewController.collectionView!.contentOffset.y

        return CGPointMake(animateToPoint.x,
                           animateToPoint.y + offset + toViewController.navigationBarHeight() + UIApplication.statusBarHeight())
    }
    
    private func setNewFrameToCells(destinationCollectionViewController: UICollectionViewController) {
        
        if let destinationIndexPathsForVisibleCells = destinationCollectionViewController.collectionView?.indexPathsForVisibleItems() {

            let sortedIndexPaths = destinationIndexPathsForVisibleCells.sort({ $0.row < $1.row })
            
            for (_, index) in sortedIndexPaths.enumerate() {
           
                if let cell = destinationCollectionViewController.collectionView?.cellForItemAtIndexPath(index),
                
                    layoutAttributes = destinationCollectionViewController.collectionView?.layoutAttributesForItemAtIndexPath(index) {
            
                        cell.frame = layoutAttributes.frame
                }
            }
        }
    }
    
    private func enumerateVisibleCellsAndAddAnimations(destinationPoint: CGPoint, sourceCollectionViewController: UICollectionViewController, destinationCollectionViewController: UICollectionViewController) {

        assert(destinationCollectionViewController.selectedIndexPath != nil, "Forgot to set selectedIndexPath property?")
        
        var sourceIndexPathsForVisibleCells = sourceCollectionViewController.collectionView?.indexPathsForVisibleItems()
        sourceIndexPathsForVisibleCells = sourceIndexPathsForVisibleCells!.sort({ $0.row < $1.row })
        
        let rowsAndColumns = destinationCollectionViewController.collectionView!.numberOfVisibleRowsAndColumn()
        
        for (idx, index) in sourceIndexPathsForVisibleCells!.reverse().enumerate() {
            
            if let cell = sourceCollectionViewController.collectionView?.cellForItemAtIndexPath(index),
                _ = sourceCollectionViewController.collectionView?.layoutAttributesForItemAtIndexPath(index),
                lastSelectedCell = destinationCollectionViewController.collectionView?.cellForItemAtIndexPath(destinationCollectionViewController.selectedIndexPath),
                flowLayout = destinationCollectionViewController.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                    
                    cell.layer.zPosition = kTopCellLayerZIndex - CGFloat(idx*self.kDeltaBetweenCellLayers)
                    
                    self.addCellReversedAnimations(destinationPoint, cell: cell, cellIndex: idx, cellSize: flowLayout.itemSize, cellBackgroundColor: lastSelectedCell.backgroundColor!, rowsAndColumns: rowsAndColumns)
            }
        }
    }
    
    private func setupDestinationViewController(destinationVC: UIViewController, context: UIViewControllerContextTransitioning) {
        //set clear color
        if let destinationCollectionViewController = destinationVC as? UICollectionViewController {
             destinationCollectionViewController.collectionView?.backgroundColor = UIColor.clearColor()
        }
        
        destinationVC.view.backgroundColor = UIColor.clearColor()
        destinationVC.view.alpha = 0.0
    }

    private func addCellReversedAnimations(animateToPoint: CGPoint, cell: UICollectionViewCell, cellIndex: Int, cellSize: CGSize, cellBackgroundColor: UIColor, rowsAndColumns: (rows: Int, columns: Int)) {
        
        let relativeStartTime = self.kCellAnimBigDelta * Double(cellIndex % rowsAndColumns.columns)
        var relativeDuration = self.animationDuration - (self.kCellAnimSmallDelta * Double(cellIndex))
        
        if (relativeStartTime + relativeDuration) > self.animationDuration {
            relativeDuration = self.animationDuration - relativeStartTime
        }
        
        UIView.animateKeyframesWithDuration(self.animationDuration, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: { () -> Void in
            
            UIView.addKeyframeWithRelativeStartTime(0.0 + (self.kCellAnimSmallDelta * Double(cellIndex)), relativeDuration: self.animationDuration - (self.kCellAnimSmallDelta * Double(cellIndex)), animations: { () -> Void in
                
                cell.backgroundColor = cellBackgroundColor
            })
            
            UIView.addKeyframeWithRelativeStartTime(relativeStartTime, relativeDuration: relativeDuration, animations: { () -> Void in
                
                cell.frame = self.centerPointWithSizeToFrame(animateToPoint, size: cellSize)
            })
            
            }, completion: { (finished) -> Void in
                
                cell.layer.zPosition = 0
        })
    }
    
    private func centerPointWithSizeToFrame(point: CGPoint, size: CGSize) -> CGRect {
        return CGRectMake(point.x - (size.width/2), point.y - (size.height/2), size.width, size.height)
    }
    
    //MARK :- UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
