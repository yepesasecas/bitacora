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
    
    @IBOutlet weak var imageView: UIImageView!

    var photo: Photo!
    var oauthswift:OAuth1Swift!
    var progressHUD: ProgressHUD!
    let oauthTokenString = "oauthToken"
    let oauthTokenSecretString = "oauthTokenSecret"
    let blogUrlString = "blogUrl"
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage(data: self.photo.imageData!)
        
        progressHUD = ProgressHUD.init(text: "loading")
        self.view.addSubview(progressHUD)
        self.progressHUD.hide()
        
        guard let oauthToken = UserDefaults.standard.string(forKey: oauthTokenString),
            let oauthTokenSecret = UserDefaults.standard.string(forKey: oauthTokenSecretString) else {
                let alert = UIAlertController(title: "No Tumblr Login Found", message: "go to config section and login to your tumblr account", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
        }
        
        oauthswift = OAuth1Swift(
            consumerKey:    "hxKOeVAQq6vxKWNva4u0PguQqqmSCZNZs5EMznGVKDm2L5xv9l",
            consumerSecret: "lFg1X6q9ZGsHolUpCZC3ZDNvZoTmbBCVKzjKDhJdqJB0ell7Y5",
            requestTokenUrl: "https://www.tumblr.com/oauth/request_token",
            authorizeUrl:    "https://www.tumblr.com/oauth/authorize",
            accessTokenUrl:  "https://www.tumblr.com/oauth/access_token"
        )
        
        oauthswift.client.credential.oauthToken = oauthToken
        oauthswift.client.credential.oauthTokenSecret = oauthTokenSecret
    }

    // MARK: - Actions
    @IBAction func upload(_ sender: Any) {
        // Convert Selected Cell to string text
        guard let blogURL = UserDefaults.standard.string(forKey: blogUrlString),
              blogURL == "",
              blogURL == " " else {
            let alert = UIAlertController(title: "No Tumblr Blog URL defined", message: "go to config section and define your Blog URL", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        
        var tags = ""
        if tableView.indexPathsForSelectedRows != nil {
            let hashtags = tableView.indexPathsForSelectedRows?.compactMap() { self.photo.hashtags?.object(at: $0.row) }
            let texts = (hashtags as! [Hashtag]).map() { $0.title! }
            tags = texts.joined(separator: ", ")
        }
        
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
            "tags": tags
        ]
        let paramsData = try? JSONSerialization.data(withJSONObject:params)
        let tumblr_url = "https://api.tumblr.com/v2/blog/\(blogURL)/posts"
        
        let dataPart = OAuthSwiftMultipartData(name: "fileId", data: self.photo.imageData!, fileName: "img.jpeg", mimeType: "image/jpeg")
        let jsonPart = OAuthSwiftMultipartData(name: "json", data: paramsData!, fileName: nil, mimeType: "application/json")
        let multiParts = [dataPart, jsonPart]
        
        multiPart(url: tumblr_url, method: .POST, params: [:], headers: nil, multiparts: multiParts, label: "MULTIPART")
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - Table view delegate

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
        cell.accessoryType = .checkmark
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Hashtags"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        cell.accessoryType = .none
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        cell.accessoryType = .checkmark
    }
    
    // Private
    
    func multiPart(url: String, method: OAuthSwiftHTTPRequest.Method, params: OAuthSwift.Parameters, headers: OAuthSwift.Headers?, multiparts: [OAuthSwiftMultipartData], label: String) {
        self.progressHUD.show(text: "Posting")
        oauthswift.client.postMultiPartRequest(url, method: method, parameters: params, headers: headers, multiparts: multiparts, checkTokenExpiration: true) { result in
            print("\n -------------- \(label) \n")
            switch result {
            case .success(let response):
                let dataString = response.string
                print(dataString)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.progressHUD.show(text: "Error!")
                print(error)
            }
        }
    }

}
