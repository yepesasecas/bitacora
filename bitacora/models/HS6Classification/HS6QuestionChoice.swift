//
//  3CEQuestionChoice.swift
//  dogs
//
//  Created by Andres Yepes on 12/27/18.
//  Copyright © 2018 limonada_de_mango. All rights reserved.
//

import UIKit

struct HS6QuestionChoice: QuestionChoice {
    
    static let type = "3ce"
    
    let id: String
    let name: String
    let value: Bool
    let type = HS6QuestionChoice.type
    
    init(dictionary: AnyObject) {
        self.id = dictionary["id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.value = dictionary["value"] as? Bool ?? false
    }
    
    // MARK: Protocol
    
    func choice() -> String {
        return id
    }
    
    func titleText() -> String {
        return name
    }
    
    func subtitleText() -> String {
        return ""
    }
    
    func isType() -> String {
        return type
    }
}
