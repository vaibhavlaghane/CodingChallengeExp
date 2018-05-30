//
//  Event.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 5/30/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

import UIKit

enum ImageDownLoadState:String  {
    case New
    case Downloaded
    case InProgress
    case Failed
}

class Event: NSObject {
    var name: String?
    var location:String?
    var date: Date
    var formattedDate:String?
    var imageData: UIImage?
    var isImageDownloaded: ImageDownLoadState = .New
    var imageURL: URL? = nil
    var imagelink: String?{
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
            if( self.imagelink != nil ){
                imageURL = URL.init(string: self.imagelink!)
            }
    }
}
