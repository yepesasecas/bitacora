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
    var hashtags: [String]!
    var photo: Photo!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    
    @IBAction func save(_ sender: Any) {
//        do {
//            let hashtagsObject = hashtags.map() { (string: String) -> Hashtag in
//                let hashtag = Hashtag.init(context: self.dataController.viewContext)
//                hashtag.title = string
//                hashtag.addToPhotos(photo)
//                print(hashtag)
//                return hashtag
//            }
//            print(hashtagsObject)
//            try dataController.viewContext.save()
//            self.navigationController?.popViewController(animated: true)
//        } catch {
//            print("unable to save hashtags")
//            print(error)
//        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hashtags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hashtagCell", for: indexPath)
        cell.textLabel?.text = hashtags[indexPath.row]
        return cell
    }

}
