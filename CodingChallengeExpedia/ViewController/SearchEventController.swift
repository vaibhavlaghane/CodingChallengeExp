//
//  SearchEventController.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 6/2/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

import UIKit

let kEventCellIdentifier = "kEventTableViewCell"
let kshowEventDetailsdentifier = "showEventDetails"
let eventCell  = "EventTableViewCell"

extension UIViewController {
    //convenience method to add a childviewcontroller
    func configureChildViewController(childController: UIViewController, onView: UIView?) {
        var holderView = self.view
        if let onView = onView {
            holderView = onView
        }
        addChildViewController(childController)
        //slide in the view from right to left
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.layer.add(transition, forKey: nil)
        
        holderView?.addSubview(childController.view)
        constrainViewEqual(holderView: holderView!, view: childController.view)
        childController.didMove(toParentViewController: self)
        childController.willMove(toParentViewController: self)
    }
    
    
    func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        //pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
    
}

class SearchEventController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var searchEventsBar: UISearchBar!
    
    @objc var netOp = NetworkOperationManager()
    var eventList = [Event]()
    var searchEventList = [Event]()
    var searchEventText = ""
    var pageNumber = 1;
    var pageSize = 30 ;
    var detailsScrVC = EventDetailsViewController.init(nibName: "EventDetailsViewController", bundle: nil)
  
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
                                    // finish infinite scroll animation
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
        self.configureChildViewController(childController: detailsScrVC, onView: self.view)
         detailsScrVC.setupParameters() ;
    }
 
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // <#code#>//    [self.mSearchBar setShowsCancelButton:NO animated:YES];
            searchEventText="";
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count > 0) {
            searchAutocomplete(searchText)
            eventsTable.reloadData()
        }
        else
        {
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
 
}
