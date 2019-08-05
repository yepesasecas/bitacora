//
//  HashtagsTableViewController.swift
//  bitacora
//
//  Created by Andres Yepes on 5/23/19.
//  Copyright © 2019 Andres Yepes. All rights reserved.
//

import UIKit
import CoreData
import OAuthSwift


class PhotoHashtagsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var dataController: DataController!
    var hashtags: [String]!
    var photo: Photo!
    var oauthswift:OAuth1Swift!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    @IBAction func upload(_ sender: Any) {
        let params: [String: Any] = [
            "content": [
                [
                    "type": "image",
                    "media": [
                        [
                            "type": "image/jpeg",
                            "identifier": "fileId",
                            "width": 250,
                            "height": 200
                        ]
                    ]
                ]
            ],
            "tags": "ios, bitacora"
        ]
        let paramsData = try? JSONSerialization.data(withJSONObject:params)
        let tumblr_url = "https://api.tumblr.com/v2/blog/shykidvoiddonut.tumblr.com/posts"
        let hook_url = "https://hookb.in/jea6RGkZy9T1012zVW97"
        
        let photoData = UIImage(named: "img.jpeg")?.jpegData(compressionQuality: 0.1)
        let dataPart = OAuthSwiftMultipartData(name: "fileId", data: photoData!, fileName: "img.jpeg", mimeType: "image/jpeg")
        let jsonPart = OAuthSwiftMultipartData(name: "json", data: paramsData!, fileName: nil, mimeType: "application/json")
        let multiParts = [dataPart, jsonPart]
        
        multiPart(url: hook_url, method: .POST, params: [:], headers: nil, multiparts: multiParts, label: "MULTIPART")
        multiPart(url: tumblr_url, method: .POST, params: [:], headers: nil, multiparts: multiParts, label: "MULTIPART")
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
    
    // Private
    
    func multiPart(url: String, method: OAuthSwiftHTTPRequest.Method, params: OAuthSwift.Parameters, headers: OAuthSwift.Headers?, multiparts: [OAuthSwiftMultipartData], label: String) {
        oauthswift.client.postMultiPartRequest(url, method: method, parameters: params, headers: headers, multiparts: multiparts, checkTokenExpiration: true) { result in
            print("\n -------------- \(label) \n")
            switch result {
            case .success(let response):
                let dataString = response.string
                print(dataString)
            case .failure(let error):
                print(error)
            }
        }
    }

}
