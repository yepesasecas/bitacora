//
//  ViewController+UIImagePickerControllerDelegate.swift
//  bitacora
//
//  Created by Andres Yepes on 5/27/19.
//  Copyright © 2019 Andres Yepes. All rights reserved.
//

import UIKit

extension PhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            let gcv = GoogleCloudVision.init()
            
            //TODO: Define best compression Quality. Trade-off
            guard let imageData = image.jpegData(compressionQuality: 0.1)  else{
                print("Unable to generate image data")
                return
            }
            
            //  Create Photo
            let photo = Photo(context: self.dataController.viewContext)
            photo.imageData = imageData
            photo.createdAt = NSDate() as Date
            photo.classified = false
    
            // Save Photo
            do {
                try dataController.viewContext.save()
            } catch {
                print("unable to save photo")
                print(error)
            }
            
            // Send imageData to Google Vision
            gcv.objectsIn(imageData: imageData){ (res, error) in
                
                // Error Guard
                if let error = error as? String{
                    print(error)
                    DispatchQueue.main.async {
                        self.progressHUD.show(text: error)
                    }
                    return
                }
                
                // Filter # of Words Array

                let hashtagsArray = (res as! [Substring]).filter() { $0.starts(with: "#") }
                
                // NO #s Found
                if hashtagsArray.count == 0 {
                    print("no hashtags found")
                    return
                }
                
                // Store Photo Hashtags
                do {
                    hashtagsArray.forEach { (string: Substring) in
                        let hashtag = Hashtag.init(context: self.dataController.viewContext)
                        hashtag.title = String(string)
                        hashtag.addToPhotos(photo)
                    }
                    
                    photo.classified = true
                    
                    try self.dataController.viewContext.save()
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    print("unable to save hashtags")
                    print(error)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func dismissModal(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
