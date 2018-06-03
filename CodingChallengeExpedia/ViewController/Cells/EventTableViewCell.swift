//
//  EventTableViewCell.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 6/2/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var venue: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var favoriteIcon: HeartButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func fillColor(){
        favoriteIcon.filled = true
        DispatchQueue.main.async {
            self.favoriteIcon.draw(self.favoriteIcon.frame)
        }
    }
}
