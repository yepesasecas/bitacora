//
//  HashtagsTableViewController.swift
//  bitacora
//
//  Created by Andres Yepes on 5/23/19.
//  Copyright © 2019 Andres Yepes. All rights reserved.
//

import UIKit
import CoreData

class PhotoHashtagsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var dataController: DataController!
    var photo: Photo!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = UIImage(data: self.photo.imageData!)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let hashtags = photo.hashtags {
            return hashtags.count
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hashtagCell", for: indexPath)
        if let hashtags = photo.hashtags {
            let hashtag = hashtags.object(at: indexPath.row) as! Hashtag
            cell.textLabel?.text = hashtag.title
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Hashtags"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        cell.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        cell.accessoryType = .none
    }
    
    // MARK: - Actions
    
    @IBAction func share(_ sender: Any) {
        let image = UIImage(data: self.photo.imageData!)!
        
        // Convert Selected Cell to string text
        var text = ""
        if tableView.indexPathsForSelectedRows != nil {
            let hashtags = tableView.indexPathsForSelectedRows?.compactMap() { self.photo.hashtags?.object(at: $0.row) }
            let texts = (hashtags as! [Hashtag]).map() { $0.title! }
            text = texts.joined(separator: " ")
        }
    
        // Activity View
        let activityView = VisualActivityViewController(activityItems: [image, text])
        activityView.completionWithItemsHandler = { (type,completed,items,error) in
            if completed {
                print("activity completionWithItemsHandler executed.")
            }
        }
        present(activityView, animated: true, completion: nil)

    }
}
