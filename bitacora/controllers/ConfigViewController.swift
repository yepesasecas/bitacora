//
//  ConfigViewController.swift
//  bitacora
//
//  Created by Andres Yepes on 8/14/19.
//  Copyright © 2019 Andres Yepes. All rights reserved.
//

import UIKit
import OAuthSwift

class ConfigViewController: UIViewController {

    
    @IBOutlet weak var oauthTokenTextField: UITextField!
    @IBOutlet weak var oauthTokenSecretTextField: UITextField!
    @IBOutlet weak var blogUrlTextField: UITextField!
    
    let oauthTokenString = "oauthToken"
    let oauthTokenSecretString = "oauthTokenSecret"
    let blogUrlString = "blogUrl"
    
    var oauthswift:OAuth1Swift!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.oauthTokenTextField.text = UserDefaults.standard.string(forKey: oauthTokenString)
        self.oauthTokenSecretTextField.text = UserDefaults.standard.string(forKey: oauthTokenSecretString)
        self.blogUrlTextField.text = UserDefaults.standard.string(forKey: blogUrlString)
    }
    
    @IBAction func tumblrLogin(_ sender: Any) {
        // create an instance and retain it
        oauthswift = OAuth1Swift(
            consumerKey:    "hxKOeVAQq6vxKWNva4u0PguQqqmSCZNZs5EMznGVKDm2L5xv9l",
            consumerSecret: "lFg1X6q9ZGsHolUpCZC3ZDNvZoTmbBCVKzjKDhJdqJB0ell7Y5",
            requestTokenUrl: "https://www.tumblr.com/oauth/request_token",
            authorizeUrl:    "https://www.tumblr.com/oauth/authorize",
            accessTokenUrl:  "https://www.tumblr.com/oauth/access_token"
        )
        
        // authorize
        oauthswift.authorize(withCallbackURL: URL(string: "bitacora://oauth-callback/twitter")!) { result in
            switch result {
            case .success(let (credential, _, _)):
                UserDefaults.standard.set(credential.oauthToken, forKey: self.oauthTokenString)
                UserDefaults.standard.set(credential.oauthTokenSecret, forKey: self.oauthTokenSecretString)
                self.oauthTokenTextField.text = credential.oauthToken
                self.oauthTokenSecretTextField.text = credential.oauthTokenSecret
            // Do your request
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    @IBAction func save(_ sender: Any) {
        UserDefaults.standard.set(self.oauthTokenTextField.text, forKey: self.oauthTokenString)
        UserDefaults.standard.set(self.oauthTokenSecretTextField.text, forKey: self.oauthTokenSecretString)
        UserDefaults.standard.set(self.blogUrlTextField.text, forKey: self.blogUrlString)
        dismiss(animated: true, completion: nil)
    }
}
