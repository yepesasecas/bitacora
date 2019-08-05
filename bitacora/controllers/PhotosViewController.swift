//
//  ViewController.swift
//  bitacora
//
//  Created by Andres Yepes on 5/23/19.
//  Copyright © 2019 Andres Yepes. All rights reserved.
//

import UIKit
import CoreData
import OAuthSwift

class PhotosViewController: UIViewController, UICollectionViewDataSource {
    
    //MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var takePicture: UIBarButtonItem!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private let reuseIdentifier = "CollectionCell"
    var progressHUD: ProgressHUD!
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<Photo>!
    var oauthswift:OAuth1Swift!
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            takePicture.isEnabled = false
        }
        
        progressHUD = ProgressHUD.init(text: "loading")
        self.view.addSubview(progressHUD)
        self.progressHUD.hide()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupFetchedResultsController()
        setFlowLayout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setFlowLayout()
    }
    
    // MARK: - Actions

    @IBAction func takePictureAction(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
    }
    
    @IBAction func tumblr(_ sender: Any) {
        // create an instance and retain it
        oauthswift = OAuth1Swift(
            consumerKey:    "hxKOeVAQq6vxKWNva4u0PguQqqmSCZNZs5EMznGVKDm2L5xv9l",
            consumerSecret: "lFg1X6q9ZGsHolUpCZC3ZDNvZoTmbBCVKzjKDhJdqJB0ell7Y5",
            requestTokenUrl: "https://www.tumblr.com/oauth/request_token",
            authorizeUrl:    "https://www.tumblr.com/oauth/authorize",
            accessTokenUrl:  "https://www.tumblr.com/oauth/access_token"
        )
        
        // authorize
        let handle = oauthswift.authorize(
        withCallbackURL: URL(string: "bitacora://oauth-callback/twitter")!) { result in
            print("wwwooo")
            switch result {
            case .success(let (credential, response, parameters)):
                print(credential.oauthToken)
                print(credential.oauthTokenSecret)
                print(parameters)
            // Do your request
            case .failure(let error):
                print(error.description)
            }
        }
    }
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        let photo = fetchedResultsController.object(at: indexPath)
        
        if let imageData = photo.imageData {
            cell.imageView.image = UIImage.init(data: imageData)
        }

        if photo.classified {
            cell.activityIndicator.stopAnimating()
        }
        
        return cell
    }
    
    // MARK: - Private
    
    func presentImagePickerWith(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.isAccessibilityElement = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "photos")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    func setFlowLayout() {
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}
