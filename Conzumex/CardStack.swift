//
//  Stack.swift
//  Conzumex
//
//  Created by Choudhary, Subham on 23/01/19.
//  Copyright © 2019 Choudhary, Subham. All rights reserved.
//

import Foundation
import UIKit

class CardStack {
    
    var expandedStack = [Card]()
    var minimizedStack = [Card]()
    
    var parentView = UIView()
    let xValue: CGFloat = 5
    let bottomSpace: CGFloat = 5
    let topSpace:CGFloat = 80
    let gap: CGFloat = 7
    var width: CGFloat = 0
    let cardHeightCollapsed: CGFloat = 80
    var shouldExpandAtLoad = false
    
    func setParentView(view: UIView) {
        
        parentView = view
        width = parentView.frame.width - (2 * xValue)
    }
    
    func appendToExpandedStack(_ card: Card) {
        
        if expandedStack.count > 0 {
            expandedStack.last!.removeGesture()
        }
        expandedStack.append(card)
        
        if expandedStack.count == 1 {
            expandedStack.last!.removeGesture()
        }
    }
    
    func appendToMinimizedStack(_ card: Card) {
        
        if minimizedStack.count > 0 {
            minimizedStack.last!.removeGesture()
        }
        card.setupGesture()
        minimizedStack.append(card)
    }
    
    func popFromExpandedStack() {
        
        expandedStack.removeLast()
        if expandedStack.count > 1 {
            expandedStack.last!.setupGesture()
        }
    }
    
    func popFromMinimizedStack() {
        
        minimizedStack.removeLast()
        if minimizedStack.count > 0 {
            minimizedStack.last!.setupGesture()
        }
    }
    
    func getExpandedFrame() -> CGRect {
        var height:CGFloat = 0
        
        if expandedStack.count > 0 {
            let maximizedY = expandedStack.last!.frame.origin.y + gap
            
            if minimizedStack.count == 1 {
                height = parentView.frame.height - maximizedY - gap
                
            } else {
                let minimizedY = minimizedStack.last!.frame.origin.y
                height = minimizedY - maximizedY - gap
            }
            return CGRect(x: xValue, y: maximizedY, width: width, height: height)
        } else {
            if minimizedStack.count > 0 {
                height = minimizedStack.last!.frame.origin.y - topSpace - gap
            } else {
                height = parentView.frame.height - topSpace - cardHeightCollapsed - gap * CGFloat(Utility.shared().trainingPlansList.count + 1)
            }
            return CGRect(x: xValue, y: topSpace, width: width, height: height)
        }
    }
    
    func getMinimizedFrame() -> CGRect {
        
        if minimizedStack.count > 0 {
            let yValue = minimizedStack.last!.frame.origin.y - gap
            return CGRect(x: xValue, y: yValue, width: width, height: cardHeightCollapsed)
        } else {
            let yValue = parentView.frame.height - cardHeightCollapsed - gap
            return CGRect(x: xValue, y: yValue, width: width, height: cardHeightCollapsed)
        }
    }
}
