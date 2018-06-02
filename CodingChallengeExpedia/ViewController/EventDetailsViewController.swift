//
//  EventDetailsViewController.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 6/2/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {

    
    @IBOutlet weak var eventVenue: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBAction func favoriteButtonClicked(_ sender: Any) {
    }
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.parent?.removeFromParentViewController()
    }
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
