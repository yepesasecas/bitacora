//
//  ViewController+UICollectionViewDelegate.swift
//  bitacora
//
//  Created by Andres Yepes on 5/27/19.
//  Copyright © 2019 Andres Yepes. All rights reserved.
//

import UIKit

extension PhotosViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = self.fetchedResultsController.object(at: indexPath)
        let photoHashtags = self.storyboard?.instantiateViewController(withIdentifier: "PhotoHashtagsTableViewController") as! PhotoHashtagsTableViewController
        photoHashtags.photo = photo
        photoHashtags.oauthswift = oauthswift
        self.navigationController?.pushViewController(photoHashtags, animated: true)
    }
}
