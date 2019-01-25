//
//  CardCell.swift
//  Conzumex
//
//  Created by Choudhary, Subham on 24/01/19.
//  Copyright © 2019 Choudhary, Subham. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
    
    @IBOutlet weak var body: UIView!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var setNumber: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    var currentState = cardState.collapsed

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
