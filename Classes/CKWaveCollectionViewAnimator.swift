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

final class CKWaveCollectionViewAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    internal var reversed: Bool = false

    internal var animationDuration: Double = 1.0
    internal let kCellAnimSmallDelta: Double = 0.01
    internal let kCellAnimBigDelta: Double = 0.03

    private let kTopCellLayerZIndex: CGFloat = 1000.0
    private let kDeltaBetweenCellLayers: Int = 2
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                transitionContext.completeTransition(true)
                return
        }

        guard let destinationCollectionViewController = toViewController as? UICollectionViewController,
            let sourceCollectionViewController = fromViewController as? UICollectionViewController else {
                assertionFailure("Source and destination view controller must be a UICollectionViewController subclass")
                return
        }

        let container = transitionContext.containerView
        container.backgroundColor = UIColor.clear

        toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        
        if reversed == false {
            container.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
            // copy colors
            let destinationViewControllerViewBackgroundColor = toViewController.view.backgroundColor
            let destinationCollectionViewBackgroundColor = destinationCollectionViewController.collectionView?.backgroundColor
            
            collectionViewTransition(toViewController,
                                     transitionContext: transitionContext,
                                     destinationCollectionViewController: destinationCollectionViewController,
                                     sourceCollectionViewController: sourceCollectionViewController,
                                     destinationViewControllerViewBackgroundColor: destinationViewControllerViewBackgroundColor,
                                     destinationCollectionViewBackgroundColor: destinationCollectionViewBackgroundColor)
        } else {
            container.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            reversedCollectionViewTransition(toViewController,
                                             fromViewController: fromViewController,
                                             transitionContext: transitionContext,
                                             sourceCollectionViewController: sourceCollectionViewController,
                                             destinationCollectionViewController: destinationCollectionViewController)
        }
    }

    // MARK: - helper private methods
    
    private func collectionViewTransition(_ toViewController: UIViewController,
                                          transitionContext: UIViewControllerContextTransitioning,
                                          destinationCollectionViewController: UICollectionViewController,
                                          sourceCollectionViewController: UICollectionViewController,
                                          destinationViewControllerViewBackgroundColor: UIColor?,
                                          destinationCollectionViewBackgroundColor: UIColor?) {
        setupDestinationViewController(toViewController, context: transitionContext)
        
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            // fake empty animation
            }) { finished -> Void in
                UIView.animate(withDuration: 0.1) {
                    toViewController.view.alpha = 1.0
                }
                
                UIView.animate(withDuration: self.animationDuration, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: { () -> Void in
                    toViewController.view.backgroundColor = destinationViewControllerViewBackgroundColor
                    destinationCollectionViewController.collectionView?.backgroundColor = destinationCollectionViewBackgroundColor
                }) { finished -> Void in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }

                self.addAnimationsToDestinationCollectionView(destinationCollectionViewController,
                                                              sourceCollectionViewController: sourceCollectionViewController,
                                                              toViewController: toViewController)
        }
    }
    
    private func reversedCollectionViewTransition(_ toViewController: UIViewController,
                                                  fromViewController: UIViewController,
                                                  transitionContext: UIViewControllerContextTransitioning,
                                                  sourceCollectionViewController: UICollectionViewController,
                                                  destinationCollectionViewController: UICollectionViewController)
    {
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            // fake empty animation
            }) { finished -> Void in
                UIView.animate(withDuration: self.animationDuration, animations: { () -> Void in
                    fromViewController.view.backgroundColor = UIColor.clear
                    sourceCollectionViewController.collectionView!.backgroundColor = UIColor.clear
                    }, completion: { finished -> Void in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })

                let destinationPoint = self.calculateDestinationAnimationPoint(sourceCollectionViewController, toViewController: toViewController)
                self.setNewFrameToCells(destinationCollectionViewController)
                self.enumerateVisibleCellsAndAddAnimations(destinationPoint, sourceCollectionViewController: sourceCollectionViewController, destinationCollectionViewController: destinationCollectionViewController)
        }
    }
    
    private func calculateSourceAnimationPoint(_ selectedCellCenter: CGPoint,
                                               sourceCollectionViewController: UICollectionViewController,
                                               destinationCollectionViewController: UICollectionViewController) -> CGPoint {
        let animateFromPoint = sourceCollectionViewController.collectionView?.convert(selectedCellCenter, to: sourceCollectionViewController.view)
        return CGPoint(x: animateFromPoint!.x,
                       y: animateFromPoint!.y - UIApplication.statusBarHeight() - destinationCollectionViewController.navigationBarHeight())
    }

    private func addAnimationsToDestinationCollectionView(_ destinationCollectionViewController: UICollectionViewController,
                                                          sourceCollectionViewController: UICollectionViewController,
                                                          toViewController: UIViewController) {
        let indexPaths = sourceCollectionViewController.collectionView.indexPathsForSelectedItems
        guard let selectedCellIndex = indexPaths?.first,
            let selectedCell = sourceCollectionViewController.collectionView.cellForItem(at: selectedCellIndex),
            let selectedCellBackgroundColor = selectedCell.backgroundColor else { return }

        let sourceAnimationPoint = calculateSourceAnimationPoint(selectedCell.center,
                                                                 sourceCollectionViewController: sourceCollectionViewController,
                                                                 destinationCollectionViewController: destinationCollectionViewController)
        destinationCollectionViewController.fromPoint = sourceAnimationPoint
        let rowsAndColumns = destinationCollectionViewController.collectionView.numberOfVisibleRowsAndColumn()
        guard let indexPathsForVisibleCells = destinationCollectionViewController.collectionView?.indexPathsForVisibleItems else { return }
        let sortedIndexPaths = indexPathsForVisibleCells.sorted(by: { $0.row < $1.row })
        for (_, index) in sortedIndexPaths.enumerated() {
            guard let cell = destinationCollectionViewController.collectionView?.cellForItem(at: IndexPath(row: index.row, section: index.section)) else { return }
            addCellAnimations(sourceAnimationPoint,
                              sourceCollectionViewController: sourceCollectionViewController,
                              destinationCollectionViewController: destinationCollectionViewController,
                              cell: cell,
                              fromCellColor: selectedCellBackgroundColor,
                              cellIndexPath: index,
                              rowsAndColumns: rowsAndColumns)
        }
    }
    
    private func addCellAnimations(_ animateFromPoint: CGPoint,
                                   sourceCollectionViewController: UICollectionViewController,
                                   destinationCollectionViewController: UICollectionViewController,
                                   cell: UICollectionViewCell,
                                   fromCellColor: UIColor,
                                   cellIndexPath: IndexPath,
                                   rowsAndColumns: (rows: Int, columns: Int)) {
        let cellOriginalColor = cell.backgroundColor
        
        // temporary change cell color to selected cell background color
        cell.backgroundColor = fromCellColor
        
        let source = sourceCollectionViewController.collectionView
        let destination = destinationCollectionViewController.collectionView
        
        guard let fromFlowLayout = source?.collectionViewLayout as? UICollectionViewFlowLayout,
            let toFlowLayout = destination?.collectionViewLayout as? UICollectionViewFlowLayout,
            let cellLayoutAttributes = destination?.layoutAttributesForItem(at: cellIndexPath) else { return }
        
            cell.frame.size = fromFlowLayout.itemSize
            cell.center = animateFromPoint
            cell.alpha = 1.0
            cell.layer.zPosition = kTopCellLayerZIndex - CGFloat(cellIndexPath.row * kDeltaBetweenCellLayers)
        
            UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: UIView.KeyframeAnimationOptions(), animations: { () -> Void in
                let relativeStartTime = (self.kCellAnimBigDelta * Double(cellIndexPath.row % rowsAndColumns.columns))
                var relativeDuration = self.animationDuration - self.kCellAnimSmallDelta * Double(cellIndexPath.row)
            
                if relativeStartTime + relativeDuration > self.animationDuration {
                    relativeDuration = self.animationDuration - relativeStartTime
                }

                UIView.addKeyframe(withRelativeStartTime: 0.0 + (self.kCellAnimBigDelta * Double(cellIndexPath.row % rowsAndColumns.columns)), relativeDuration: relativeDuration) {
                    cell.backgroundColor = cellOriginalColor
                }

                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1) {
                    cell.alpha = 1.0
                }

                UIView.addKeyframe(withRelativeStartTime: 0.0 + (self.kCellAnimBigDelta * Double(cellIndexPath.row % rowsAndColumns.columns)), relativeDuration: relativeDuration) {
                    cell.frame = self.centerPointWithSizeToFrame(cellLayoutAttributes.center, size: toFlowLayout.itemSize)
                }
            }, completion: { _ -> Void in
                    cell.layer.zPosition = 0
            }
        )
    }
    
    private func calculateDestinationAnimationPoint(_ sourceCollectionViewController: UICollectionViewController,
                                                    toViewController: UIViewController) -> CGPoint {
        guard let animateToPoint = sourceCollectionViewController.fromPoint else { return CGPoint.zero }
        let offset = sourceCollectionViewController.collectionView.contentOffset.y

        return CGPoint(x: animateToPoint.x,
                       y: animateToPoint.y + offset + toViewController.navigationBarHeight() + UIApplication.statusBarHeight())
    }
    
    private func setNewFrameToCells(_ destinationCollectionViewController: UICollectionViewController) {
        guard let destinationIndexPathsForVisibleCells = destinationCollectionViewController.collectionView?.indexPathsForVisibleItems else { return }
        let sortedIndexPaths = destinationIndexPathsForVisibleCells.sorted(by: { $0.row < $1.row })
        for (_, index) in sortedIndexPaths.enumerated() {
            guard let cell = destinationCollectionViewController.collectionView?.cellForItem(at: index),
                let layoutAttributes = destinationCollectionViewController.collectionView?.layoutAttributesForItem(at: index) else { return }

            cell.frame = layoutAttributes.frame
        }
    }
    
    private func enumerateVisibleCellsAndAddAnimations(_ destinationPoint: CGPoint,
                                                       sourceCollectionViewController: UICollectionViewController,
                                                       destinationCollectionViewController: UICollectionViewController) {
        assert(destinationCollectionViewController.selectedIndexPath != nil, "Forgot to set selectedIndexPath property?")
        
        guard let sourceIndexPathsForVisibleCells = sourceCollectionViewController.collectionView?.indexPathsForVisibleItems.sorted(by: { $0.row < $1.row }) else { return }
        guard let rowsAndColumns = destinationCollectionViewController.collectionView?.numberOfVisibleRowsAndColumn() else { return }
        
        for (idx, index) in sourceIndexPathsForVisibleCells.reversed().enumerated() {
            guard let cell = sourceCollectionViewController.collectionView?.cellForItem(at: index),
                let _ = sourceCollectionViewController.collectionView?.layoutAttributesForItem(at: index),
                let destinationIndexPath = destinationCollectionViewController.selectedIndexPath,
                let lastSelectedCell = destinationCollectionViewController.collectionView?.cellForItem(at: destinationIndexPath),
                let lastSelectedCellBackgroundColor = lastSelectedCell.backgroundColor,
                let flowLayout = destinationCollectionViewController.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }

            cell.layer.zPosition = kTopCellLayerZIndex - CGFloat(idx * kDeltaBetweenCellLayers)
            addCellReversedAnimations(destinationPoint,
                                      cell: cell,
                                      cellIndex: idx,
                                      cellSize: flowLayout.itemSize,
                                      cellBackgroundColor: lastSelectedCellBackgroundColor,
                                      rowsAndColumns: rowsAndColumns)
        }
    }

    private func setupDestinationViewController(_ destinationVC: UIViewController, context: UIViewControllerContextTransitioning) {
        // set clear color
        if let destinationCollectionViewController = destinationVC as? UICollectionViewController {
             destinationCollectionViewController.collectionView?.backgroundColor = UIColor.clear
        }
        
        destinationVC.view.backgroundColor = UIColor.clear
        destinationVC.view.alpha = 0.0
    }

    private func addCellReversedAnimations(_ animateToPoint: CGPoint,
                                           cell: UICollectionViewCell,
                                           cellIndex: Int,
                                           cellSize: CGSize,
                                           cellBackgroundColor: UIColor,
                                           rowsAndColumns: (rows: Int, columns: Int)) {
        let relativeStartTime = kCellAnimBigDelta * Double(cellIndex % rowsAndColumns.columns)
        var relativeDuration = animationDuration - (kCellAnimSmallDelta * Double(cellIndex))
        
        if (relativeStartTime + relativeDuration) > animationDuration {
            relativeDuration = animationDuration - relativeStartTime
        }
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: UIView.KeyframeAnimationOptions(), animations: { () -> Void in
            UIView.addKeyframe(withRelativeStartTime: 0.0 + (self.kCellAnimSmallDelta * Double(cellIndex)), relativeDuration: self.animationDuration - (self.kCellAnimSmallDelta * Double(cellIndex))) {
                cell.backgroundColor = cellBackgroundColor
            }

            UIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: relativeDuration) {
                cell.frame = self.centerPointWithSizeToFrame(animateToPoint, size: cellSize)
            }
        }, completion: { _ -> Void in
            cell.layer.zPosition = 0
        })
    }
    
    private func centerPointWithSizeToFrame(_ point: CGPoint, size: CGSize) -> CGRect {
        return CGRect(x: point.x - (size.width / 2), y: point.y - (size.height / 2), width: size.width, height: size.height)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
