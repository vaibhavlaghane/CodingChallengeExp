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
    @IBOutlet weak var favoriteButton: HeartButton!
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        if(!favoriteButton.filled){
            favoriteButton.filled = true
            DispatchQueue.main.async {
                self.favoriteButton.draw(self.favoriteButton.frame)
            }
            
        }else{
            favoriteButton.filled = false
            DispatchQueue.main.async {
                self.favoriteButton.draw(self.favoriteButton.frame)
            }
        }
    }
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBAction func backButtonPressed(_ sender: Any) {
        self.moveView(view: self.view)
    }
    @IBOutlet weak var backButton: UIButton!
    
    var eventName : String = "" ;
    var date : String = "" ;
    var venue : String  = "" ;
    var isFavoriteEvent = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventVenue.text = venue
        eventDate.text = date
        eventTitleLabel.text = eventName
        eventImage.layer.cornerRadius = 0.8
        
        if (isFavoriteEvent){
            favoriteButton.filled = true
            DispatchQueue.main.async {
                self.favoriteButton.draw(self.favoriteButton.frame)
            }
            
        }
        //let heartButton =  HeartButton(frame: favoriteButton.frame)
       // favoriteButton = heartButton
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveView(view: UIView){
        
        // Notify Child View Controller
        self.willMove(toParentViewController: nil)
        self.beginAppearanceTransition(false, animated: true)
        // Remove Child View From Superview
        self.view.removeFromSuperview()
        // Notify Child View Controller
        self.removeFromParentViewController()
//        return childViewController
//
//        let toPoint: CGPoint =  CGPoint(x:  0.0, y: view.frame.size.width)//  CGPointMake(0.0, -10.0)
//        let fromPoint : CGPoint = CGPoint.zero
//        let movement = CABasicAnimation(keyPath: "movement")
//        movement.isAdditive = true
//        movement.fromValue =  NSValue(cgPoint: fromPoint)
//        movement.toValue =  NSValue(cgPoint: toPoint)
//        movement.duration = 1.5
//        view.layer.add(movement, forKey: "move")
//
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
