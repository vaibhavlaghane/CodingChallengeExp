//
//  Event.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 5/30/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

import UIKit

enum ImageDownLoadState:String  {
    case new
    case downloaded
    case nnProgress
    case failed
}

class Event: NSObject {

    public private(set) var name: String?
    public private(set) var location:String?
    public private(set) var date: Date
    public private(set) var formattedDate:String?
    var imageData: UIImage?
    var isImageDownloaded: ImageDownLoadState = .new
    public private(set) var imageURL: URL? = nil
    
    public private(set) var imagelink: String?{
        didSet{
            if( imagelink != nil ){
                imageURL = URL.init(string: imagelink!)
            }
        }
    }
    
    init(name: String?,
        location: String?,
        date: Date?,
        formattedDate: String?,
        imagelink: String?)
        {
            self.name = name ?? "";
            self.location = location ?? "";
            self.date = (date ?? nil)! ;
            self.formattedDate = formattedDate ?? "";
            if(imagelink != nil ){
                imageURL = URL.init(string: imagelink!)
            }
    }
}
