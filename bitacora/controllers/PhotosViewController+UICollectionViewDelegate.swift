//
//  ViewController+UICollectionViewDelegate.swift
//  bitacora
//
//  Created by Andres Yepes on 5/27/19.
//  Copyright © 2019 Andres Yepes. All rights reserved.
//

import UIKit

extension PhotosViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("Cell selected")
        let photo = self.fetchedResultsController.object(at: indexPath)
    }
}
