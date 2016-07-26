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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        let vc = self.storyboard?.instantiateViewController(withIdentifier: kThirdVCId) as? ThirdCollectionViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    //MARK :- UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) 
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }    
}
