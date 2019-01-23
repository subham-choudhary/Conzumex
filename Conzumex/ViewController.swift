//
//  ViewController.swift
//  Conzumex
//
//  Created by Choudhary, Subham on 22/01/19.
//  Copyright © 2019 Choudhary, Subham. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var card: Card?
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInturepted:CGFloat = 0
    var cardVisible = false
    var cardHeightExpanded:CGFloat = 600
    let cardHeightCollapsed:CGFloat = 80
    
    enum cardState {
        case expanded
        case collapsed
    }
    var nextState: cardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardHeightExpanded = self.view.frame.height - cardHeightCollapsed
        Utility.shared().parentView = self.view
        setupCard()
    }
    
    func setupCard() {
        card = Bundle.main.loadNibNamed("Card", owner: self, options: nil)?.first as? Card
        self.view.addSubview(card!)
    }
}


