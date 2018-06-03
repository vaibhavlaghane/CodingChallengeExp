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
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.moveView(view: self.view)
    }
    
    var eventName : String = "" ;
    var date : String = "" ;
    var venue : String  = "" ;
    var isFavoriteEvent = false;
    var eventDetails = Event(name: "", location: "", date: Date() , formattedDate: "", imagelink: "", detailImageLink: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventVenue.text = venue
        eventDate.text = date
        eventTitleLabel.text = eventName
        
        if (isFavoriteEvent){
            favoriteButton.filled = true
            DispatchQueue.main.async {
                self.favoriteButton.draw(self.favoriteButton.frame)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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

    //setup parameters of the view 
    func setupParameters(){
        eventVenue.text = venue
        eventDate.text = date
        eventTitleLabel.text = eventName
        eventImage.setRadius(radius: 8.0)
        if  let imagURL = eventDetails.detailImageURL  {
            if let  imageData =   try? Data(contentsOf: imagURL){
                let imageUI = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.eventImage.image = imageUI
                }
            }
        }
    }
    
}
