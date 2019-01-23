//
//  Cards.swift
//  Conzumex
//
//  Created by Choudhary, Subham on 22/01/19.
//  Copyright © 2019 Choudhary, Subham. All rights reserved.
//

import UIKit

class Card: UIView {
    
    @IBOutlet weak var head: UIView!
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
        setupGesture()
    }
    
    func setupView() {
        
        cardHeightExpanded = (Utility.shared().parentView.frame.height) - cardHeightCollapsed - 50
        self.frame = CGRect(x: 5, y: (Utility.shared().parentView.frame.height) - cardHeightCollapsed - 20, width: (Utility.shared().parentView.frame.width) - 10, height: cardHeightCollapsed)
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
    }
    
    func setupGesture() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        
        head.addGestureRecognizer(tapGestureRecognizer)
        head.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 1)
        case .changed:
            let translation = recognizer.translation(in: self.superview)
            var fractionComplete = translation.y/cardHeightExpanded
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default: print("[Default Case]") ; break
        }
    }
    
    func startInteractiveTransition(state: cardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            addAnimation(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInturepted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInturepted
        }
    }
    
    func continueInteractiveTransition(){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    func addAnimation(state: cardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let animator = UIViewPropertyAnimator(duration: 0.1, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.frame.origin.y = 20
                    self.frame.size.height = self.cardHeightExpanded
                case .collapsed:
                    self.frame.origin.y = (Utility.shared().parentView.frame.height) - self.cardHeightCollapsed - 20
                    self.frame.size.height = self.cardHeightCollapsed
                }
            }
            animator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            animator.startAnimation()
            runningAnimations.append(animator)
        }
    }
}
