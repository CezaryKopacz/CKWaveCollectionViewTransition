//
//  SecondCollectionViewController.swift
//  CKWaveCollectionViewTransition
//
//  Created by Salvation on 7/13/15.
//  Copyright (c) 2015 CezaryKopacz. All rights reserved.
//

import UIKit

class SecondCollectionViewController: UICollectionViewController {

    let kThirdVCId = "thirdVC"
    let kCellId = "cellId"
    
    //MARK :- UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedIndexPath = indexPath
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(kThirdVCId) as? ThirdCollectionViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    //MARK :- UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellId, forIndexPath: indexPath) 
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }    
}
