//
//  ImageDownloader.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 5/30/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

import UIKit

class ImageDownloader: Operation {

    var  event: Event
    var  imageData: Data? = nil
    
    init(event: Event) {
        self.event = event
    }
    
    override func main() {
        if self.isCancelled   {
            return
        }
        
        if let imgURL = self.event.imageURL{
            imageData =   try? Data(contentsOf: imgURL)
        }else{
            event.isImageDownloaded = .failed
            return
            //log - imageURL is nil, cannot download the image
        }
        
        if imageData != nil {
            self.event.imageData = UIImage(data:imageData!)
            self.event.isImageDownloaded = .downloaded
        }
        else
        {
            self.event.isImageDownloaded = .failed
            self.event.imageData = UIImage(named: "Failed")
        }
    }
}
