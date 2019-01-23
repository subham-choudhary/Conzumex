//
//  trainingModel.swift
//  Conzumex
//
//  Created by Choudhary, Subham on 22/01/19.
//  Copyright © 2019 Choudhary, Subham. All rights reserved.
//

import Foundation

struct TrainingPlan {
    
    var week: Int?
    var restDays: [String]?
    var plan: [Plan]?
}

struct Plan {
    
    var day: String?
    var details: Details?
    var title: String?
}

struct Details {
    
    var benifits: String?
    var session: Session?
}

struct Session {
    
    var description: String?
    var goal: Goal?
    var intensity: String?
    var name: String?
    var sets: Int?
}

struct Goal {
    
    var amount: Int?
    var type: String?
    var unit: String?
}
