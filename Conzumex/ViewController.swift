//
//  ViewController.swift
//  Conzumex
//
//  Created by Choudhary, Subham on 22/01/19.
//  Copyright © 2019 Choudhary, Subham. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var expandedStack = [Card]()
    var minimizedStack = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCard()
        setupCard()
        setupCard()
        setupCard()
    }
    
    func setupCard() {
        Utility.shared().parentView = self.view
        if let card = Bundle.main.loadNibNamed("Card", owner: self, options: nil)?.first as? Card {
            self.view.addSubview(card)
            self.minimizedStack.append(card)
        }
        
    }
}


