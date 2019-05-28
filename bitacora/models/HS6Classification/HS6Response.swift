//
//  3CEResponse.swift
//  dogs
//
//  Created by Andres Yepes on 12/27/18.
//  Copyright © 2018 limonada_de_mango. All rights reserved.
//

import UIKit

struct HS6Response {
    
    let txId: String?
    let interactionId: String?
    let status: String?
    let response: AnyObject?
    let hsCode: String?
    let label: String?
    var questions: [HS6QuestionChoice] = []
    
    init(dictionary: AnyObject) {
        txId = dictionary["tx_id"] as? String
        interactionId = dictionary["interaction_id"] as? String
        status = dictionary["status"] as? String
        response = dictionary["response"] as? AnyObject
        hsCode = response?["hs_code"] as? String
        label = response?["label"] as? String
        
        if let tempQuestions = response?["question"] as? [AnyObject] {
            questions = tempQuestions.map() { HS6QuestionChoice.init(dictionary: $0) }
        }
        
        
    }
}
