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
            self.progressHUD?.show(text: "processing...")
            
            guard let imageData = image.jpegData(compressionQuality: 0.1)  else{
                print("Unable to generate image data")
                return
            }
            
            let photo = Photo(context: self.dataController.viewContext)
            photo.imageData = imageData
            
            do {
                try dataController.viewContext.save()
            } catch {
                print("unable to save photo")
                print(error)
            }
            
            
            gcv.objectsIn(imageData: imageData){ (res, error) in
                
                if let error = error as? String{
                    print(error)
                    DispatchQueue.main.async {
                        self.progressHUD.show(text: error)
                    }
                }
                
                DispatchQueue.main.async {
                    self.progressHUD?.hide()
                    print(res)
                    if let res = res as? [Substring] {
                        let hashtagsVC = self.storyboard?.instantiateViewController(withIdentifier: "HashtagsTableViewController") as! HashtagsTableViewController
                        hashtagsVC.hashtags = res.map { String($0) }
                        self.navigationController?.pushViewController(hashtagsVC, animated: true)
                    }
                    else {
                        self.progressHUD?.show(text: ":(")
                    }
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
