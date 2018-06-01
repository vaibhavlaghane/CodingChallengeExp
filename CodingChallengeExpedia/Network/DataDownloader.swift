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
        static let APIPath = "/2/events"
        static let queryClientId = "client_id"
        static let APIKey = "b698e0a86dc6ed97744c480bfb558b6c3fb04d06081502905472255561d5af9c"
        static let CLIENTID = "MTE3NTYyOTV8MTUyNzY5Njg4Mi45Mg"
        static let perPage = "per_page="
        static let page = "page="
        static let and = "&"
        static let q = "?"
    }
}

struct EndPoints  {
    static let  Events  = "events"
    static let  Perfomers = "performers"
    static let  Venues = "venues"
    static let  None = ""
}

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
            }else if(error != nil )
            {
                failure(nil, error! );
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
        components.path     = Constants.APIDetails.APIPath
        components.query   = Constants.APIDetails.queryClientId + "=" + Constants.APIDetails.CLIENTID
        //components.path     = Constants.APIDetails.APIPath + "\(Constants.APIDetails.APIKey)" + "/\(pageNumber)" + "/\(pageSize)/" ;
        
        return components.url!
    }
}
