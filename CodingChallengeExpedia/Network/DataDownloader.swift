//
//  DataDownloaded.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 5/30/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//
//MTE3NTYyOTV8MTUyNzY5Njg4Mi45Mg
//Your app secret is
//b698e0a86dc6ed97744c480bfb558b6c3fb04d06081502905472255561d5af9c
import UIKit

struct Constants {
    struct APIDetails {
       // https://api.seatgeek.com/2/venues?
        static let APIScheme = "https"
        static let APIHost = "api.seatgeek.com"
        static let APIPath = "/events"
        static let APIKey = "b698e0a86dc6ed97744c480bfb558b6c3fb04d06081502905472255561d5af9c"
        static let CLIENTID = "MTE3NTYyOTV8MTUyNzY5Njg4Mi45Mg"
    }
}

enum EndPoints:String  {
    case Events  = "events"
    case Perfomers = "performers"
    case Venues = "venues"
    case None = ""
}

//enum EndPoints{
// events =  "/events"
///events/{EVENT_ID}
///performers
///performers/{PERFORMER_ID}
///venues
///venues/{VENUE_ID}
//}
class DataDownloader: NSObject {

    /// function call to get JSON data
    /// completion block handles the received JSON
    /// - Returns: none
    internal func getJSONData( pageNumber: Int, pageSize: Int  , completion: @escaping (Dictionary<String, Any >? ) -> Void , failure: @escaping (URLResponse? , Error? ) -> Void  )->Void   {
        
        var pageNumStr = String( pageNumber)
        var pageSizeStr = String(pageSize)
        if   pageNumber < 1  {
            pageNumStr = "1"
        }
        if (pageSize > 30 || pageSize < 1){
            pageSizeStr = "30"
        }
        
        let urlUsr = createURLFromParameters(  pageSizeStr,  pageNumStr) ;
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: urlUsr  )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: request as URLRequest){(data: Data?,response: URLResponse?, error: Error?) -> Void in
            if let responseData = data
            {
                do{
                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                    //print(json)
                    completion(json as? Dictionary<String, Any >)
                }catch{
                    print("Could not serialize")
                    completion(nil)
                }
            }
            }.resume()
    }
    
    ///  function to create URL using the paramenters
    /// - Parameters:
    ///   - pageSize: page size
    ///   - pageNumber: page number
    /// - Returns: url
    internal func createURLFromParameters(_ pageSize:  String, _ pageNumber: String ) -> URL {
        var components      = URLComponents()
        components.scheme   = Constants.APIDetails.APIScheme
        components.host     = Constants.APIDetails.APIHost
        components.path     = Constants.APIDetails.APIPath + "\(Constants.APIDetails.APIKey)" + "/\(pageNumber)" + "/\(pageSize)/" ;
        
        return components.url!
    }
}
