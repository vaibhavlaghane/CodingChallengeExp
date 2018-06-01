//
//  SearchTableViewController.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 5/30/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

import UIKit

let kEventCellIdentifier = "kEventCell"
let kshowEventDetailsdentifier = "showEventDetails"
//let kshowCollectionViewdentifier = "showCollectionView"
//let kshowProductDetailsCollectiondentifier = "showProductDetailsCollection"
//let kproductDetailViewControllerIdentifier = "productDetailViewControllerID"
//let kProductChildViewControllerNibName = "ProductChildViewController"
//static let MAXPAGENUMBER = 30
//static let MAXPAGENUMBER = 30

let eventCell  = "EventCell"

class SearchTableViewController: UITableViewController , UISearchBarDelegate{
    @IBOutlet weak var searchEvents: UISearchBar!
    
    var eventList = [Event]()
    @objc var netOp = NetworkOperationManager()
    var pageNumber = 1;
    var pageSize = 30 ;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        netOp.downloadData(pageNumber: pageNumber, pageSize: pageSize) { (products) in
            self.eventList = self.netOp.events
            self.pageNumber = self.pageNumber + self.pageSize ;
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        eventList = netOp.events
        self.tableView.estimatedRowHeight =   UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 55.0;
        
       // tableView.register(UINib(nibName: eventCell, bundle: nil), forCellReuseIdentifier: kEventCellIdentifier)
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
        return eventList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  cellP = tableView.dequeueReusableCell(withIdentifier: kEventCellIdentifier, for: indexPath) as? EventCell
        if let cell = cellP {
            // Configure the cell...
            if (indexPath.row < eventList.count){
                let evnt: Event = eventList[indexPath.row]
                cell.eventLabel.text = evnt.name ?? ""
            }
            return cell
        }
        cellP = EventCell()
        return cellP!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: kshowEventDetailsdentifier, sender: indexPath);
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
        removeObserver(self, forKeyPath: "products")
    }
    
// mark - search field delegate methods
    func searchBarShouldBeginEditing()->ObjCBool  {
        return true;
    }
    

    
     func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return false;
    }// return NO to not become first responder
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       // <#code#>
    }
//    @available(iOS 2.0, *)
//    optional public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) // called when text starts editing
//
//    @available(iOS 2.0, *)
//    optional public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool // return NO to not resign first responder
//
//    @available(iOS 2.0, *)
//    optional public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) // called when text ends editing
//
//    @available(iOS 2.0, *)
//    optional public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) // called when text changes (including clear)
//
//    @available(iOS 3.0, *)
//    optional public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool // called before text changes
//
//    - (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    //when enter is pressed in keyboarb --- start the data search operation
//    [_searchBar resignFirstResponder ];
//    if (searchBar.text != nil  ) {
//    if (dataTask != nil) {
//    [dataTask cancel];
//
//    }
//    NSCharacterSet * expectedCharSet = [NSCharacterSet  URLQueryAllowedCharacterSet];
//    NSString* searchTerm = [searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:expectedCharSet ];
//    NSString* url = [  @"https://itunes.apple.com/search?term=" stringByAppendingString:searchTerm ];
//    //call the API to search the entered track name
//    [self downloadJSONData:url];
//    //@synchronized (tracksArray) {
//    if(tracksArray){
//    //Once json is download - we have retrieved the file details and url paths for images - download the images/posters
//    [self downloadImages:tracksArray];
//    }
//    //}
//    }
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
