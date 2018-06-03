//
//  SearchEventController.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 6/2/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

import UIKit

let kEventCellIdentifier = "kEventTableViewCell"
let eventCell  = "EventTableViewCell"

class SearchEventController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,ChildTransitionDelegate  {

    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var searchEventsBar: UISearchBar!
    
    @objc var netOp = NetworkOperationManager()
    var eventList = [Event]()
    var searchEventList = [Event]()
    var searchEventText = ""
    var pageNumber = 1;
    var pageSize = 30 ;
    var detailsScrVC = EventDetailsViewController.init(nibName: "EventDetailsViewController", bundle: nil)
    var currentIndex = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventsTable.estimatedRowHeight =   UITableViewAutomaticDimension
        self.eventsTable.estimatedRowHeight = 135.0;
        netOp.downloadData(pageNumber: pageNumber, pageSize: pageSize) { (events) in
            self.eventList = self.netOp.events
            self.searchEventList = self.eventList
            self.pageNumber = self.pageNumber + self.pageSize ;
            DispatchQueue.main.async {
                self.eventsTable.reloadData()
            }
        }
        eventList = netOp.events
        searchEventList = eventList
        eventsTable.register(UINib(nibName: eventCell, bundle: nil), forCellReuseIdentifier: kEventCellIdentifier)
        
        //infinite scroll setup for fetching data page after page
        self.eventsTable.addInfiniteScroll { (tableView) -> Void in
             self.netOp.downloadData(pageNumber: self.pageNumber, pageSize: self.pageSize) { (events ) in
                if let  eventsSearched: Array<Event> = events{
                    self.eventList.append(contentsOf:  eventsSearched)
                    if(self.searchEventText.count > 0 ){
                        self.searchAutocomplete(self.searchEventText )
                    }else{
                        self.searchEventList = self.eventList
                    }
                    self.pageNumber = self.pageNumber + self.pageSize ;
                    DispatchQueue.main.async {
                        self.eventsTable.reloadData()
                        self.eventsTable.finishInfiniteScroll()
                    }
                }
            }
        }
        eventsTable.finishInfiniteScroll()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchEventList.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  cellP = tableView.dequeueReusableCell(withIdentifier: kEventCellIdentifier, for: indexPath) as? EventTableViewCell
        if let cell = cellP {
            // Configure the cell...
            if (indexPath.row < searchEventList.count){
                let evnt: Event = searchEventList[indexPath.row]
                cell.title.text = evnt.name ?? ""
                cell.venue.text = evnt.location ?? ""
                cell.date.text = evnt.formattedDate ?? ""
                if ( evnt.imageData != nil ){
                    cell.imageEvent.image =    evnt.imageData
                    cell.imageEvent.setRadius(radius: 8.0)
                }else{
                    cell.imageEvent.image =    UIImage(named: "ghostimage")
                    cell.imageEvent.setRadius(radius: 8.0)
                }
                if(checkFavorite(evnt.iD)){
                    DispatchQueue.main.async {
                        cell.fillColor()
                        cell.favoriteIcon.isHidden = false
                    }
                }else{
                    DispatchQueue.main.async {
                        cell.favoriteIcon.isHidden = true
                    }
                }
                
            }
            return cell
        }
        cellP = EventTableViewCell()
        return cellP!
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = searchEventList[indexPath.row]
        detailsScrVC.eventName = event.name ?? ""
        detailsScrVC.venue = event.location ?? ""
        detailsScrVC.date = event.formattedDate ?? ""
        detailsScrVC.isFavoriteEvent = false;//
        detailsScrVC.eventDetails = event
        detailsScrVC.delegate =  self;
        currentIndex = indexPath.row
        
        self.configureChildViewController(childController: detailsScrVC, onView: self.view)
         detailsScrVC.setupParameters() ;
        
    }
 
    //Mark - searchBar delegate methos
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchEventText="";
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count > 0) {
            searchAutocomplete(searchText)
            eventsTable.reloadData()
        }else{
            searchEventText = ""
            searchEventList = eventList;
            eventsTable.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchEventsBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchEventsBar.resignFirstResponder()
        searchEventList = eventList;
        eventsTable.reloadData()
    }
    
    func searchAutocomplete(_ substring: String)
    {
        searchEventText = substring
        var searchedArray  = [Event]()
        for curEvent in eventList
        {
            let eventString = curEvent.name as! String
            let compareString = eventString.prefix(substring.count)
            if let substringRange :Range<String.Index> = compareString.range(of: substring){
                if (!(substringRange.isEmpty) ){searchedArray.append(curEvent)}
            }
        }
        searchEventList.removeAll()
        searchEventList = searchedArray
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
    
    //Mark - delegate to hide child view controller
    func dismissChildController() {
        let childVC = self.childViewControllers
        for(_ , child ) in childVC.enumerated(){
            if( child.isKind(of: EventDetailsViewController.self)){
                //slide in the view from right to left
                let transition = CATransition()
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromLeft
                self.view.layer.add(transition, forKey: nil)
                child.view.removeFromSuperview()
                child.removeFromParentViewController()
                
                let indexPath = IndexPath(item: currentIndex, section: 0)
                self.eventsTable.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    func dismissChildController(_ childController: UIViewController) {
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        childController.view.layer.add(transition, forKey: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    
}
