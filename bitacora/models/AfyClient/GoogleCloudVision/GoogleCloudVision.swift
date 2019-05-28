//
//  GoogleCloudVision.swift
//  dogs
//
//  Created by Andres Yepes on 9/10/18.
//  Copyright © 2018 limonada_de_mango. All rights reserved.
//

import UIKit

class GoogleCloudVision: NSObject {
    let path: String = "/api/v1/google_cloud/vision"
    let afyClient = AfyClient.init()
    
    func objectsIn(imageData: Data, closure: @escaping (Any?, Any?) -> Void) {
        
        let imageBase64 = imageData.base64EncodedString()
        let body = ["image": ["source": imageBase64]]
        let url = URL(string: "\(afyClient.host)\(path)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(afyClient.token, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("unable to serialize object to data")
            return
        }
        
        urlRequest.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            
            if let res = response as? HTTPURLResponse,
                res.statusCode != 200 {
                    if res.statusCode == 401 {
                        closure(nil, "401: Unauthorized")
                        return
                    }
                    else if res.statusCode == 500{
                        closure(nil, "500: Internal Server Error")
                        return
                    }
                    else if res.statusCode == 413{
                        closure(nil, "413: Payload Too Large")
                        return
                    }
                    else {
                        closure(nil, "\(res.statusCode): TODO Review new response status code")
                        return
                    }
            }
            
            if let error = error {
                closure(nil, error)
            }
            
            guard let data = data else{
                closure(nil, "no data returned.")
                return
            }
            
            guard let resJson = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject,
                  let responsesJson = resJson["responses"] as? [AnyObject],
                  let fullTextAnnotation = responsesJson[0]["fullTextAnnotation"] as? AnyObject,
                  let text = fullTextAnnotation["text"] as? String else {
                      closure(nil, "unable to decode Data to JSON Object")
                      return
            }
            let textArray = text.split(separator: "\n")
            closure(textArray, nil)
        }
        
        task.resume()
    }
}
