//
//  CSWebShotTests.swift
//  CSWebShotTests
//
//  Created by Cătălin Stan on 13/10/2016.
//  Copyright © 2016 Cătălin Stan. All rights reserved.
//

import XCTest
import CSWebShot

class CSWebShotTests: XCTestCase {

    func testWebshot() {
        let expectation = self.expectation(description: "Webshot generated")
        let webshotFetcher = CSWebShot(url: URL(string: "https://criollo.io/")!)

        webshotFetcher.webshot { (action, data, error) in
            XCTAssertTrue(action == WSAction.webShot)
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 60)
    }

    func testWebshotFailure() {

        let expectation = self.expectation(description: "Webshot failed to get the content")
        let webshotFetcher = CSWebShot()

        webshotFetcher.webshot { (action, data, error) in
            XCTAssertTrue(action == WSAction.webShot)
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 60)
    }

    func testHTML() {
        let expectation = self.expectation(description: "HTML Fetched")
        let htmlFetcher = CSWebShot(url: URL(string: "https://criollo.io/")!)

        htmlFetcher.renderedHTML { (action, data, error) in
            XCTAssertTrue(action == WSAction.fetchHTML)
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 60)
    }

    func testHTMLFailure() {

        let expectation = self.expectation(description: "HTML failed to get the content")
        let htmlFetcher = CSWebShot()

        htmlFetcher.renderedHTML { (action, data, error) in
            XCTAssertTrue(action == WSAction.fetchHTML)
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 60)
    }
}
