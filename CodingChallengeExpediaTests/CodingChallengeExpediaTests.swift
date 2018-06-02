//
//  CodingChallengeExpediaTests.swift
//  CodingChallengeExpediaTests
//
//  Created by Vaibhav N Laghane on 5/30/18.
//  Copyright © 2018 TestExpedia. All rights reserved.
//

import XCTest
@testable import CodingChallengeExpedia

class CodingChallengeExpediaTests: XCTestCase {
    var  netCall:DataDownloader? = nil
    var events: [Event]? = nil
//    var eID: String = "0150f9b5-8918-4fd1-92b3-fc032cc6c684"
    var netOps: NetworkOperationManager? = nil
    var imageLink: String =  "https://chairnerd.global.ssl.fastly.net/images/performers-landscape/puff-jam-5-7b6e46/536644/huge.jpg"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        netCall = DataDownloader()
        netOps = NetworkOperationManager()
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testNetworkOperation(){
        
        XCTAssertNotNil(netOps)
        XCTAssertNotNil(netCall)
        
    }
    
    func testURLCreation(){
        let url = netCall?.createURLFromParameters("30", "1")
        XCTAssertNotNil(url)
        print(url ?? " ");
    }
    
    func testNetworkCall(){
        let expectation = self.expectation(description: "fetch posts")
        netCall?.getJSONData( pageNumber: 1, pageSize: 30, completion: { (dict ) in
            XCTAssertNotNil(dict)
            print(dict ?? "")
            expectation.fulfill()
        },failure: {( response, error) in
            //
        })
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testgetEvent(){
        let expectation = self.expectation(description: "fetch Event")
        netCall?.getJSONData( pageNumber: 1, pageSize: 1, completion: { (dict ) in
            XCTAssertNotNil(dict)
            print(dict ?? "")
            self.events = Utility.parseJSON(dict: dict)
            let evnt = self.events![0] as? Event
           // XCTAssertEqual(evnt?.id, self.eID)
            expectation.fulfill()
        },failure: {( response, error) in
            //
        })
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetImage(){
        
    }
    
    func testimageDownloader(){
        var imageData: Data? = nil
        if let imgURL =   URL.init(string: imageLink) {
            imageData =   try? Data(contentsOf: imgURL)
        }
        
        XCTAssertNotNil(imageData)
    }
    
}
