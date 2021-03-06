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
            if  let event = element as? Dictionary< String, Any?>{
                let performers : Array<Dictionary<String, Any>> = event[EventDetails.performers] as! Array<Dictionary<String,Any>>
                let dateTimeLocal : String = event[ EventDetails.dateTimeLocal] as? String ?? ""
                let dateTimeUTC : String = event[EventDetails.dateTimeUTC] as? String ?? ""
                let venueDict : Dictionary<String, Any > = event[EventDetails.venue] as! Dictionary<String, Any>
                let city: String = venueDict[ Venue.city]   as? String ?? ""
                let state : String  = venueDict[Venue.state]  as? String ?? ""
                let perDict   = performers[0]
                var imageURL = ""
                
                if( perDict [ Performer.image] != nil && !(perDict[ Performer.image] is NSNull )){
                if let imageStr: String = perDict[Performer.image]! as! String{
                        imageURL = imageStr
                    }
                }
                var detailImageURL = imageURL
                
                if let imagesDict =  perDict[Performer.images] as! Dictionary<String,  Any>?{
                    if( imagesDict[Images.huge] != nil){
                        detailImageURL = imagesDict[Images.huge] as! String
                    }else if( imagesDict[Images.large] != nil){
                        detailImageURL = imagesDict[Images.large] as! String
                    }else if( imagesDict[Images.medium] != nil){
                        detailImageURL = imagesDict[Images.medium] as! String
                    }else if( imagesDict[Images.large] != nil){
                        detailImageURL = imagesDict[Images.small] as! String
                    }
                }
               // let country: String = venueDict[Venue.country]  as!  String
               // let stats = event[EventDetails.stats] ?? ""
                let title = event[EventDetails.title]  as? String ?? ""
                let _:String  = event[EventDetails.url] as? String ?? ""
                let location = city + "," + state
                
                let iDNum = event[EventDetails.id] as! Int 
                let iD = String(iDNum)
                
                let dateTimeFormatted = Utility.getDateString(dateTimeLocal )
                
                let eventD = Event(id: iD,
                                   name: title,
                                   location: location,
                                   date: Date(),
                                   formattedDate: dateTimeFormatted,
                                   imagelink: imageURL,
                                   detailImageLink: detailImageURL)
                events.append(eventD)
            }
        }
        return events
    }
    
    /// get date in text display format
    ///
    /// - Parameter dateStr: input date string
    /// - Returns: user friendly date string 
    static func getDateString( _ dateStr: String? ) -> String {
        guard let string = dateStr else{return  ""}
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "EEE, dd MMM yyyy, HH:mm  a"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        return dateString
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
