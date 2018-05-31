//
//  Utility.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 5/30/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//
struct  EventDetails{
    static let stats = "stats"
    static let title =  "title"
     static let url = "url"
     static let dateTimeLocal = "datetime_local"
     static let performers = "performers"
     static let venue = "venue"
     static let address = "address"
     static let id = "id"
     static let shortTitle = "short_title"
     static let dateTimeUTC = "datetime_utc"
     static let score = "score"
     static let taxonomies = "taxonomies"
     static let type = "type"
}


struct  Venue{
     static let  city = "city"
     static let  name = "name"
     static let  extendedAddress = "extended_address"
     static let  url = "url"
     static let  country = "country"
     static let  state = "state"
     static let  score = "score"
     static let  postalCode = "postal_code"
     static let  location = "location"
     static let address = "address"
     static let id = "id"
}

struct Location{
    static let lat = "lat"
    static let lon = "lon"
}

struct  Stats {
     static let  listingCount        =  "listing_count"
     static let  averagePrice      = "average_price"
     static let  lowestPrice         = "lowest_price"
     static let  highestPrice       = "highest_price"
}

struct Performer{
    static let  name        =  "name"
    static let  shortName =   "short_name"
    static let  url = "url"
    static let  image = "image"
    static let  images =  "images"
    static let  primary = "primary"
    static let  id = "id"
    static let  score = "score"
    static let  type = "type"
    static let  slug = "slug"
}

struct Images {
     static let  large = "large"
     static let  huge = "huge"
     static let  small = "small"
     static let  medium = "medium"
}

struct Taxonomies{
    static let parentID = "parent_id"
    static let id = "id"
    static let name = "name"
}

import UIKit

class Utility: NSObject {
    
    /// parse the json
    ///
    /// - Parameter dict: dictonary JSON
    /// - Returns: array of Event
    static func parseJSON(dict: Dictionary<String, Any>?)-> [Event] {
        guard let jsonDict   = dict  else{return [] }
        guard let eventArr = jsonDict["events"] as? Array<Any?> else {return  [] }
        
      
        var events = [Event]()
        
        for (_,element) in eventArr.enumerated(){
            
            if  let prd = element as? Dictionary< String, Any>{
//
//                let productID = prd["productId"] ?? ""
//                let productName = prd["productName"] ?? ""
//                let shortDescription = prd["shortDescription"] ?? ""
//                let longDescription = prd["longDescription"] ?? ""
//                let price = prd["price"] ?? ""
//                let productImage = prd["productImage"] ?? ""
//                let reviewRating = prd["reviewRating"] ?? 0
//                let reviewCount = prd["reviewCount"] ?? 0
//                let inStock = prd["inStock"] ?? false
                
//                let product = Product(productId:productID as? String  ,
//                                      productName: productName  as? String ,
//                                      shortDescription: shortDescription as? String ,
//                                      longDescription: longDescription as? String ,
//                                      price: price as? String ,
//                                      imagelink: productImage as? String ,
//                                      reviewRating: reviewRating  as? Int,
//                                      reviewCount: reviewCount as? Int,
//                                      inStock: inStock  as? Bool)
//
//                products.append(product)
//
            }
        }
        
        return events
    }
    
    
    class func showAlertMessage(_ message: String, withTitle title: String, onClick completion: @escaping () -> Void) {
        let alert = UIAlertController(title: " \(title)", message: message, preferredStyle: .alert)
        //Add Buttons
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            //Handle button action here
            completion()
        })
        alert.addAction(okButton)
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}
