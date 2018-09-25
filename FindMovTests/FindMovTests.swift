//
//  FindMovTests.swift
//  FindMovTests
//
//  Created by Rathish Kannan on 9/20/18.
//  Copyright © 2018 Rathish Kannan. All rights reserved.
//

import XCTest
@testable import FindMov

class FindMovTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    ///Load test for API
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let manager = SearchManager()
            let query =  SearchQuery(query: "man", page: "1", id: "", count: "")
            manager.searchMovies(query: query.id, page: String(query.page)){  (results) in
                XCTAssert(query.page == String(results?.page ?? 1))
            }
            
        }
    }
    
    func testSaveDuplicateRecents() {
        let manager = SearchManager()
        _ = manager.saveRecentSearch(searchString: "nike")
        _ = manager.saveRecentSearch(searchString: "nike")
        _ = manager.saveRecentSearch(searchString: "nike2")
        let recents = manager.retriveRecentSearch() as! [String]
        let r1 = recents[0]
        let r2 = recents[1]
        XCTAssert(r1 != r2)
    }
    
    /// Result & Equating the qureies for safety!
    func testItemsAfterPagination() {
        let manager = SearchManager()
        let query =  SearchQuery(query: "man", page: "1", id: "", count: "")
        let query2 = SearchQuery(query: "man", page: "2", id: "", count: "")

        manager.searchMovies(query: query.id, page: String(query.page)){  (results) in
            XCTAssert(query.page == String(results?.page ?? 1))
        }
        
        manager.searchMovies(query: query2.id, page: String(query2.page)){  (results) in
            XCTAssert(query2.page == String(results?.page ?? 1))
        }
        
        //Thanks to Equatables!
        XCTAssert(query != query2)

    }
    
    
}
