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
    var cardStack = CardStack()
    
}

// MARK: JSON SERIALIZATION
extension Utility {
    
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
                trainingPlansList = trainingPlansList.reversed()
            }}}
    
    private func fetchPlans(_ plans: [[String:Any]]) -> [Plan] {
        
        var planList = [Plan]()
        for planDict in plans {
            var details: Details?
            if let detailDict = planDict["details"] as? [String : Any] {
                details = fetchDetail(detailDict)
            }
            let planObject = Plan(day: planDict["day"] as? String, details: details, title: planDict["title"] as? String, isExpanded: false)
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

// MARK: UIVIEW EXTENTION

extension UIView {
    
    func addShadow(radius: CGFloat, opacity: Float, offsetHeight: CGFloat) {
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: offsetHeight)
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shouldRasterize = true
        layer.masksToBounds = false
    }
}

extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.3) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
