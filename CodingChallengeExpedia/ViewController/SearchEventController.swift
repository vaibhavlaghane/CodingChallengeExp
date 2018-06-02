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
    func configureChildViewController(childController: UIViewController, onView: UIView?) {
        var holderView = self.view
        if let onView = onView {
            holderView = onView
        }
        addChildViewController(childController)
        
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
    var pageNumber = 1;
    var pageSize = 30 ;
    
    var detailsScrVC = EventDetailsViewController.init(nibName: "EventDetailsViewController", bundle: nil)
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventsTable.estimatedRowHeight =   UITableViewAutomaticDimension
        self.eventsTable.estimatedRowHeight = 155.0;
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
       // detailsScrVC.view.frame = self.view.frame
        // Do any additional setup after loading the view.
          eventsTable.register(UINib(nibName: eventCell, bundle: nil), forCellReuseIdentifier: kEventCellIdentifier)
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
        
        self.configureChildViewController(childController: detailsScrVC, onView: self.view)
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // <#code#>//    [self.mSearchBar setShowsCancelButton:NO animated:YES];
        //    searchBar.text=@"";
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count > 0) {
            //searchText =  " "
            searchAutocomplete(searchText)
            eventsTable.reloadData()
        }
        else
        {
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
        var searchedArray  = [Event]()
        for curEvent in eventList
        {
            let eventString:String! = curEvent.name as! String
            if let substringRange :Range<String.Index> = eventString.range(of: substring){
                if (!(substringRange.isEmpty) ){searchedArray.append(curEvent)}
            }
        }
        searchEventList.removeAll()
        searchEventList = searchedArray
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
