//
//  ViewController.swift
//  CKWaveCollectionViewTransition
//
//  Created by Salvation on 7/13/15.
//  Copyright (c) 2015 CezaryKopacz. All rights reserved.
//

import UIKit

final class MainViewController: UICollectionViewController {
  
    private let kSecondVCId = "secondVC"
    private let kCellId = "cellId"
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        guard let secondViewController = storyboard?.instantiateViewController(withIdentifier: kSecondVCId) as? SecondCollectionViewController else { return }
        navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) 
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Configuration.numberOfItems
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

private enum Configuration {
    static let numberOfItems: Int = 18
}
