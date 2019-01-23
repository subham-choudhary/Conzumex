//
//  Utility.swift
//  Conzumex
//
//  Created by Choudhary, Subham on 22/01/19.
//  Copyright © 2019 Choudhary, Subham. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    
    
    private static let sharedInstance = Utility()
    
    static func shared() -> Utility {
        return sharedInstance
    }
    private init() {
        loadJson()
    }
    
    var trainingPlansList = [TrainingPlan]()
    var parentView = UIView()
    
    private func loadJson() {
        
        if let filePath = Bundle.main.path(forResource: "trainingPlan", ofType: "json"), let data = NSData(contentsOfFile: filePath) {
            do {
                if let json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                    fetchDataFromJson(json)
                }
            }
            catch {
                print("[Can't Load Json]")
            }
        }
    }
    
    private func fetchDataFromJson(_ json: [String:Any]) {
        if let trainingPlans = json["Training Plans"] as? [String:Any] {
            if let schedule = trainingPlans["schedule"] as? [Any] {
                for item in schedule {
                    if let itemDict = item as? [String:Any] {
                        var plans = [Plan]()
                        if let planDictList = itemDict["plan"] as? [[String:Any]] {
                            plans = fetchPlans(planDictList)
                        }
                        let trainingPlanObject = TrainingPlan(week: itemDict["week"] as? Int, restDays: itemDict["restDays"] as? [String], plan: plans )
                        trainingPlansList.append(trainingPlanObject)
                    }
                }
            }}}
    
    private func fetchPlans(_ plans: [[String:Any]]) -> [Plan] {
        
        var planList = [Plan]()
        for planDict in plans {
            var details: Details?
            if let detailDict = planDict["details"] as? [String : Any] {
                details = fetchDetail(detailDict)
            }
            let planObject = Plan(day: planDict["day"] as? String, details: details, title: planDict["title"] as? String)
            planList.append(planObject)
        }
        return planList
    }
    
    private func fetchDetail(_ detail: [String:Any]) -> Details {
        
        var session: Session?
        if let sessionDict = detail["session"] as? [[String:Any]],  sessionDict.count > 0  {
            session = fetchSession(sessionDict.first!)
        }
        return Details(benifits: detail["benefits"] as? String, session: session)
    }
    
    private func fetchSession(_ session: [String:Any]) -> Session {
        
        var goal: Goal?
        if let goalDict = session["goal"] as? [String:Any]  {
            goal = fetchGoal(goalDict)
        }
        return Session(description: session["description"] as? String, goal: goal, intensity: session["intensity"] as? String, name: session["name"] as? String, sets: session["sets"] as? Int)
    }
    
    private func fetchGoal(_ goal: [String:Any]) -> Goal {
        
        return Goal(amount: goal["amount"] as? Int, type: goal["type"] as? String, unit: goal["unit"] as? String)
    }
    
    
}
