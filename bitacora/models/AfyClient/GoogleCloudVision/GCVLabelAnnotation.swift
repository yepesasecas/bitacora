//
//  GCVLabelAnnotation.swift
//  dogs
//
//  Created by Andres Yepes on 9/11/18.
//  Copyright © 2018 limonada_de_mango. All rights reserved.
//

import UIKit

struct GCVLabelAnnotation {
    
    static let type = "image"
    
    let description: String
    let mid: String
    let score: Double
    let topicality: Double
    let type = GCVLabelAnnotation.type
    
    init(dictionary: AnyObject) {
        self.description = dictionary["description"] as? String ?? ""
        self.mid = dictionary["mid"] as? String ?? ""
        self.score = dictionary["score"] as? Double ?? 0
        self.topicality = dictionary["topicality"] as? Double ?? 0
    }
    
    // MARK: Protocol
    func choice() -> String {
        return description
    }
    
    func titleText() -> String {
        return description
    }
    
    func subtitleText() -> String {
        return "\(score)"
    }
    
    func isType() -> String {
        return self.type
    }
}
