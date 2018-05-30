//
//  Utility.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 5/30/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

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
