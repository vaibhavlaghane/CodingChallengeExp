//
//  EventDetailsViewController.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 6/2/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

import UIKit

let favoritesSet = "favoritesSet"

protocol ChildTransitionDelegate {
    func dismissChildController()
    func dismissChildController(_ childController: UIViewController)
}

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
            saveFavorite(eventDetails.iD, true)
            DispatchQueue.main.async {
                self.favoriteButton.draw(self.favoriteButton.frame)
            }
        }else{
            favoriteButton.filled = false
            saveFavorite(eventDetails.iD, false )
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
    var eventDetails = Event(id: "" , name: "", location: "", date: Date() , formattedDate: "", imagelink: "", detailImageLink: "")
    var delegate : SearchEventController? = nil 
        
    override func viewDidLoad() {
        super.viewDidLoad()
        eventVenue.text = venue
        eventDate.text = date
        eventTitleLabel.text = eventName
 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveView(view: UIView){
        delegate?.dismissChildController()
    }

    //setup parameters of the view 
    func setupParameters(){
        eventImage.image = nil 
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
        
        if(checkFavorite( eventDetails.iD )){
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
    
    func saveFavorite(_  iD: String?  , _  save: Bool){
        guard let id = iD else { return }
        var favoritesDictionary: Dictionary<String, Int >
        
        if let fD =  UserDefaults.standard.dictionary(forKey: favoritesSet) as! Dictionary<String, Int >?{
            favoritesDictionary = fD
        }else{
            favoritesDictionary = Dictionary<String, Int >()
        }
        if(save){
            favoritesDictionary[id] = 1
            UserDefaults.standard.set(favoritesDictionary, forKey: favoritesSet) //setObject
        }else{
                favoritesDictionary.removeValue(forKey: id)
                UserDefaults.standard.set(favoritesDictionary, forKey: favoritesSet) //setObject
        }
        
        UserDefaults.standard.synchronize()
    }
    
    func checkFavorite(_  iD: String?)-> Bool{
        if(iD == nil ){ return false }
        if let id = iD{
            if(id.count == 0){ return false }
            if let fD =  UserDefaults.standard.dictionary(forKey: favoritesSet) as! Dictionary<String, Int >?{
                if (fD[id] == 1){
                    return true
                }
            }
        }
        return false ;
    }
}
