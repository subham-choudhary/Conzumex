//
//  ViewController.swift
//  Conzumex
//
//  Created by Choudhary, Subham on 22/01/19.
//  Copyright © 2019 Choudhary, Subham. All rights reserved.
//

import UIKit

class TrainingViewController: UIViewController {
    
    let cardStack = Utility.shared().cardStack
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<Utility.shared().trainingPlansList.count {
            
            if i == Utility.shared().trainingPlansList.count - 1 {
                cardStack.shouldExpandAtLoad = true
            }
            setupCard(trainingPlan: Utility.shared().trainingPlansList[i])
        }
    }
    
    func setupCard(trainingPlan: TrainingPlan) {
        cardStack.setParentView(view: self.view)
        if let card = Bundle.main.loadNibNamed("Card", owner: self, options: nil)?.first as? Card {
            card.delegate = self
            card.trainingPlanData = trainingPlan
            card.tableView.reloadData()
            card.addShadow(radius: 1, opacity: 0.1, offsetHeight: 0)
            self.view.addSubview(card)
            if cardStack.shouldExpandAtLoad {
                cardStack.shouldExpandAtLoad = false
                cardStack.appendToExpandedStack(card)
            } else {
                cardStack.appendToMinimizedStack(card)
            }
        }
    }
}

extension TrainingViewController: CardProtocol {
    
    func changedState(obj: Card, state: cardState) {
        if state == .expanded {
            cardStack.popFromMinimizedStack()
            cardStack.appendToExpandedStack(obj)
        } else {
            cardStack.popFromExpandedStack()
            cardStack.appendToMinimizedStack(obj)
        }
    }
}


