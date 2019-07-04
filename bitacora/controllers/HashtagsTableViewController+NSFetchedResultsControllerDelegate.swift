//
//  HashtagsTableViewController+NSFetchedResultsControllerDelegate.swift
//  bitacora
//
//  Created by Andres Yepes on 5/29/19.
//  Copyright © 2019 Andres Yepes. All rights reserved.
//

import UIKit
import CoreData

extension HashtagsTableViewController:NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("ProductsTableViewController(70): TODO")
        self.tableView.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        print("ProductsTableViewController(74): TODO")
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("ProductsTableViewController(79): TODO")
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("ProductsTableViewController(83): TODO")
    }
}
