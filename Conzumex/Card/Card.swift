//
//  Cards.swift
//  Conzumex
//
//  Created by Choudhary, Subham on 22/01/19.
//  Copyright © 2019 Choudhary, Subham. All rights reserved.
//

import UIKit

enum cardState {
    case expanded
    case collapsed
}

protocol CardProtocol {
    func changedState(obj: Card, state: cardState)
}


class Card: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var head: UIView!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var headTitle: UILabel!
    @IBOutlet weak var headDetails: UILabel!
    
    var delegate: CardProtocol?
    let cardStack = Utility.shared().cardStack
    var parentView = Utility.shared().cardStack.parentView
    var currentState = cardState.collapsed
    let animationSpeed = 0.2
    var trainingPlanData: TrainingPlan?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        loadNib()
        setTableSectionHeight()
        hideFloatingSection()
    }
    
    func setupView() {
        if cardStack.shouldExpandAtLoad {
            self.frame = cardStack.getExpandedFrame()
            currentState = .expanded
            
        } else {
            self.frame = cardStack.getMinimizedFrame()
        }
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        head.addShadow(radius: 10, opacity: 0.5, offsetHeight: 5)
    }
    
    func loadNib() {
        self.tableView.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "cardcell")
        
    }
    
    func setTableSectionHeight () {
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = 65
        self.tableView.delegate = self
    }
    
    func hideFloatingSection() {
        let tempHeight = CGFloat(65)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: tempHeight))
        self.tableView.contentInset = UIEdgeInsetsMake(-tempHeight, 0, 0, 0)
    }
    
    func setupGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        head.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func removeGesture() {
        head.gestureRecognizers?.removeAll()
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        self.superview?.bringSubview(toFront: self)
        switch currentState {
        case .collapsed:
            UIView.animate(withDuration: animationSpeed) {
                self.frame = self.cardStack.getExpandedFrame()
                self.tableView.frame.size.height = self.frame.height - self.cardStack.cardHeightCollapsed
            }
            
        case .expanded:
            UIView.animate(withDuration: animationSpeed) {
                self.frame = self.cardStack.getMinimizedFrame()
                self.tableView.frame.size.height = 0
            }
        }
        currentState = currentState == .collapsed ? .expanded : .collapsed
        self.delegate?.changedState(obj: self, state: self.currentState)
    }
    
    func getRowCells(indexPath: IndexPath) -> UITableViewCell {
        
        var cell:CardCell! = tableView.dequeueReusableCell(withIdentifier: "cardcell", for:indexPath) as! CardCell
        if cell == nil {
            let cellnib = Bundle.main.loadNibNamed("CardCell", owner: self, options: nil)
            cell = cellnib?.first! as! CardCell
        }
        cell.details.text = trainingPlanData!.plan![indexPath.section].details?.benifits
        cell.name.text = trainingPlanData!.plan![indexPath.section].details?.session?.name
        cell.desc.text = trainingPlanData!.plan![indexPath.section].details?.session?.description
        if let setNum = (trainingPlanData!.plan![indexPath.section].details?.session?.sets) {
            cell.setNumber.text = String(describing: setNum)
        }
        if let time = trainingPlanData!.plan![indexPath.section].details?.session?.goal?.amount {
            cell.time.text = String(describing: time)
        }
        return cell
    }
    
    func getHeader(section: Int) -> UIView {
        
        let viewNib = Bundle.main.loadNibNamed("CardCellHeader", owner: self, options: nil)
        let header = viewNib?.first! as! CardCellHeader
        let button = UIButton()
        button.addTarget(self, action: #selector(handleTapSection(button:)), for: .touchUpInside)
        button.frame = header.frame
        button.tag = section
        button.isUserInteractionEnabled = true
        header.addSubview(button)
        
        header.title.text = trainingPlanData!.plan![section].title
        UIView.animate(withDuration: 0.3) {
            if self.trainingPlanData!.plan![section].isExpanded! {
                header.arrow.image = #imageLiteral(resourceName: "up")
            } else {
                header.arrow.image = #imageLiteral(resourceName: "down")
            }
        }
        return header
    }
    
    @objc func handleTapSection(button: UIButton) {
        
        let section = button.tag
        if trainingPlanData!.plan![section].isExpanded! {
            
            trainingPlanData!.plan![section].isExpanded! = !(trainingPlanData!.plan![section].isExpanded!)
            tableView.deleteRows(at: [IndexPath(row: 0, section: section)], with: .fade)
            tableView.reloadSections([section], with: .fade)
        } else {
            trainingPlanData!.plan![section].isExpanded! = !(trainingPlanData!.plan![section].isExpanded!)
            tableView.reloadSections([section], with: .fade)
        }
    }

}
//MARK: TABLE VIEW DELEGATE
extension Card: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return getRowCells(indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (trainingPlanData?.plan![section].isExpanded!)! ? 1 : 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let _ = trainingPlanData {
            headTitle.text = "Week \((trainingPlanData?.week)!)"
            headDetails.text = "\(trainingPlanData!.plan!.count) Sessions, Jan 01 - 06"
            return trainingPlanData!.plan!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return getHeader(section: section)
    }
}


