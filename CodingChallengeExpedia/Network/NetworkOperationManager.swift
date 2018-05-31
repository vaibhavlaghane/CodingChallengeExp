//
//  NetworkOperationManager.swift
//  CodingChallengeExpedia
//
//  Created by Vaibhav N Laghane on 5/30/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

import UIKit

class PendingOperations {
    lazy var downloadsInProgress = [Int:Operation]()
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class NetworkOperationManager: NSObject {
 
    let downloader = DataDownloader()
    @objc    public dynamic var events = [Event]()
    let pendingOperations = PendingOperations()
    
    /// download JSON data for given page and size
    ///
    /// - Parameters:
    ///   - pageNumber: page number
    ///   - pageSize: size of page
    ///   - completion: completion block
    func downloadData( pageNumber: Int,pageSize: Int,  completion: @escaping ([Event]? ) -> Void )->Void{
        downloader.getJSONData(pageNumber: pageNumber, pageSize: pageSize, completion: { (dict) in
            
            let eventList = Utility.parseJSON(dict: dict)
            self.events.append(contentsOf:eventList  )
            
            completion(eventList)
            
            for (index, element) in self.events.enumerated(){
                self.startDownloadImage(event: element, index: index )
            }
        }) { (response, error) in   //
            Utility.showAlertMessage("Failed to Download the Content", withTitle: "Download Update", onClick: {
                NSLog(error as! String)
            })
            NSLog(error as! String)
        }
    }
    
    /// starte image download operation
    ///
    /// - Parameters:
    ///   - event: Event
    ///   - index: index of event
    func startOperationsEvent(event: Event, index: Int){
        switch (event.isImageDownloaded) {
        case .new:
            startDownloadImage(event: event, index: index)
        default:
            NSLog("do nothing")//buble error up ?
        }
    }
    
    /// method starts the image download operation on the OperationQueue
    ///
    /// - Parameters:
    ///   - event: event to download the image for
    ///   - indexPath: index of the product in the array
    func startDownloadImage(event: Event, index: Int){
        
        if let _ = pendingOperations.downloadsInProgress[index ] {
            return
        }
        let downloader = ImageDownloader(event: event)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: index )
            }
        }
        
        pendingOperations.downloadsInProgress[index ] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}
