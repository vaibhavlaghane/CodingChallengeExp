//
//  EventDetailsViewController.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 6/2/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {

    var eventName : String = "" ;
    var date : String = "" ;
    var venue : String  = "" ;
    
    @IBOutlet weak var eventVenue: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBAction func favoriteButtonClicked(_ sender: Any) {
    }
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBAction func backButtonPressed(_ sender: Any) {
        self.moveView(view: self.view)
    }
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventVenue.text = venue
        eventDate.text = date
        eventTitleLabel.text = eventName
        
        //var  image = eventImage.view
        eventImage.layer.cornerRadius = 0.8
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveView(view: UIView){
        let toPoint: CGPoint =  CGPoint(x:  0.0, y: view.frame.size.width)//  CGPointMake(0.0, -10.0)
        let fromPoint : CGPoint = CGPoint.zero
        let movement = CABasicAnimation(keyPath: "movement")
        movement.isAdditive = true
        movement.fromValue =  NSValue(cgPoint: fromPoint)
        movement.toValue =  NSValue(cgPoint: toPoint)
          //view.layer.position = toPoint;
        movement.duration = 1.5
        view.layer.add(movement, forKey: "move")
        //view.layer.ani
      
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
