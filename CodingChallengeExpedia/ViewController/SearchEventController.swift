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

class SearchEventController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var searchEventsBar: UISearchBar!
    
    @objc var netOp = NetworkOperationManager()
    var eventList = [Event]()
    var searchEventList = [Event]()
    var pageNumber = 1;
    var pageSize = 30 ;
    
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
        self.performSegue(withIdentifier: kshowEventDetailsdentifier, sender: indexPath);
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
        //        searchedDataArray=dataArray;
        //        [self.mTableView reloadData];
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
