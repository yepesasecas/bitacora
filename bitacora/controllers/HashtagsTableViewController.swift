//
//  HashtagsTableViewController.swift
//  bitacora
//
//  Created by Andres Yepes on 5/29/19.
//  Copyright © 2019 Andres Yepes. All rights reserved.
//

import UIKit
import CoreData
import OAuthSwift

class HashtagsTableViewController: UITableViewController {
    
    // MARK: - Attributes
    private let reuseIdentifier = "HashtagTableViewCell"
    var progressHUD: ProgressHUD!
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<Hashtag>!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressHUD = ProgressHUD.init(text: "loading")
        self.view.addSubview(progressHUD)
        self.progressHUD.hide()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupFetchedResultsController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    // MARK: - Delegates

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let hashtag = fetchedResultsController.object(at: indexPath)
        if let title = hashtag.title {
            cell.textLabel?.text = title
        }
        
        return cell
    }
    
    // MARK: - private
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Hashtag> = Hashtag.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

}
