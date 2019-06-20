//
//  NYC_SchoolsTests.swift
//  NYC SchoolsTests
//
//  Created by MAC on 6/20/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import XCTest
@testable import NYC_Schools

class NYC_SchoolsTests: XCTestCase {

    override func setUp() { }
    
    override func tearDown() { }
    
    func test_can_parse_schools() {
        let expectation = XCTestExpectation(description: "Test Parse Schools")
        let service: SchoolService = ProxySchoolService()
        service.getSchools { (schools) in
            guard let schools = schools else {
                XCTFail("Nil returned")
                return
            }
            XCTAssertFalse(schools.isEmpty, "No schools found")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_can_parse_schools_and_scores() {
        let expectation = XCTestExpectation(description: "Test Parse Schools And Scores")
        let service: SchoolService = ProxySchoolService()
        
        // task to get scores
        let getScores: ()->() = {
            service.getScores { (schools) in
                guard let schools = schools else {
                    XCTFail("Nil returned")
                    return
                }
                XCTAssertFalse(schools.isEmpty, "No schools found")
                expectation.fulfill()
            }
        }
        
        // task to get schools
        let getSchools: ()->() = {
            service.getSchools { (schools) in
                guard let schools = schools else {
                    XCTFail("Nil returned")
                    return
                }
                XCTAssertFalse(schools.isEmpty, "No schools found")
                getScores()
            }
        }
        
        // start tests
        getSchools()
        wait(for: [expectation], timeout: 2.0)
    }

}
