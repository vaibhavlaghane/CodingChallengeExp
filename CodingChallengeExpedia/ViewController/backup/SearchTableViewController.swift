//
//  SearchTableViewController.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 5/30/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

import UIKit

let kEventCellId  = "kEventCell"
let kshowEventDetailsId  = "showEventDetails"
let eventCellName  = "EventCell"

class SearchTableViewController: UITableViewController , UISearchBarDelegate{
    @IBOutlet weak var searchEvents: UISearchBar!
    @objc var netOp = NetworkOperationManager()
    var eventList = [Event]()
    var searchEventList = [Event]()
    var pageNumber = 1;
    var pageSize = 30 ;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        netOp.downloadData(pageNumber: pageNumber, pageSize: pageSize) { (events) in
            self.eventList = self.netOp.events
            self.searchEventList = self.eventList
            self.pageNumber = self.pageNumber + self.pageSize ;
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        eventList = netOp.events
        searchEventList = eventList
        self.tableView.estimatedRowHeight =   UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 55.0;
      
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchEventList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  cellP = tableView.dequeueReusableCell(withIdentifier: kEventCellId , for: indexPath) as? EventCell
        if let cell = cellP {
            // Configure the cell...
            if (indexPath.row < searchEventList.count){
                let evnt: Event = searchEventList[indexPath.row]
                cell.eventLabel.text = evnt.name ?? ""
            }
            return cell
        }
        cellP = EventCell()
        return cellP!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: kshowEventDetailsId, sender: indexPath);
    }
    
    /*
     MARK: - Navigation
     In a storyboard-based application, you will often want to do a little preparation before navigation  */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == kshowEventDetailsdentifier){
            let destViewController                  =   segue.destination as! EventDetailsViewController
            let indexPath = sender as? IndexPath
//             destViewController.product           =   catalogList[(indexPath?.row)!]
//             destViewController.productsList = catalogList
        }
    }
    
    deinit {
        //removeObserver(self, forKeyPath: "products")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // <#code#>//    [self.mSearchBar setShowsCancelButton:NO animated:YES];
        //    searchBar.text=@"";
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count > 0) {
            //searchText =  " "
            searchAutocomplete(searchText)
            self.tableView.reloadData()
        }
        else
        {
            searchEventList = eventList;
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchEvents.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchEvents.resignFirstResponder()
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
