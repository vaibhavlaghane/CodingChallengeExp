//
//  EventCellTableViewCell.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 5/30/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

import UIKit

class EventCellTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
