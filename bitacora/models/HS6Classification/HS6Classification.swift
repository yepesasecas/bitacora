//
//  HS6Classification.swift
//  dogs
//
//  Created by Andres Yepes on 12/27/18.
//  Copyright © 2018 limonada_de_mango. All rights reserved.
//

import UIKit

class HS6Classification: NSObject {
    let path: String = "/api/v1/classify"
    let afyClient = AfyClient.init()
    
    func product(description: String, closure: @escaping (HS6Response?, Any?) -> Void) {
        
        let body = ["description": description]
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
            
            let responseJson = self.validateResponse(data, response, error, closure)
            if responseJson != nil {
                let hs6Response = HS6Response(dictionary: responseJson!)
                closure(hs6Response, nil)
            }
        }
        
        task.resume()
    }
    
    func answer(question: HS6Response, choice: HS6QuestionChoice, closure: @escaping (HS6Response?, Any?) -> Void) {
        
        let body : [String : Any] = [
            "tx_id": question.txId!,
            "interaction_id": question.interactionId!,
            "answer": [
                choice.name: choice.id
            ]
        ]
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
            
            let responseJson = self.validateResponse(data, response, error, closure)
            if responseJson != nil {
                let hs6Response = HS6Response(dictionary: responseJson!)
                closure(hs6Response, nil)
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private
    
    func validateResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ closure: @escaping (HS6Response?, Any?) -> Void) -> AnyObject? {
        if let res = response as? HTTPURLResponse,
            res.statusCode != 200 {
            if res.statusCode == 401 {
                closure(nil, "401: Unauthorized")
                return nil
            }
            else if res.statusCode == 500{
                closure(nil, "500: Internal Server Error")
                return nil
            }
            else if res.statusCode == 413{
                closure(nil, "413: Payload Too Large")
                return nil
            }
            else {
                closure(nil, "\(res.statusCode): TODO Review new response status code")
                return nil
            }
        }
        
        if let error = error {
            closure(nil, error.localizedDescription)
        }
        
        guard let data = data else{
            closure(nil, "no data returned.")
            return nil
        }
        
        guard let resJson = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject else {
            closure(nil, "unable to decode Data to JSON Object")
            return nil
        }
        
        return resJson
    }
}
