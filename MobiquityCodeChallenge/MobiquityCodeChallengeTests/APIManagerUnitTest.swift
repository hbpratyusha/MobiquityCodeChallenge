//
//  APIManagerUnitTest.swift
//  MobiquityCodeChallengeTests
//
//  Created by Mac on 02/07/21.
//  Copyright © 2021 Mobiquity. All rights reserved.
//

import XCTest
@testable import MobiquityCodeChallenge
class APIManagerUnitTest: XCTestCase {
    var sut: APIManager!
    let networkMonitor = NetworkMonitor.shared
    override func setUpWithError() throws {
        sut = APIManager()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    func testAPICorrectResponse() throws {
        try XCTSkipUnless(
        networkMonitor.isReachable,
        "Network connectivity needed for this test.")
        let promise = expectation(description: "Completion handler invoked")
        sut.requestWith(urlString: "http://api.openweathermap.org/data/2.5/weather?lat=17.6868&lon=83.2185&appid=fae7190d7e6433ec3a45285ffcf55c86", params: nil, model: ForeCastModel.self) { (response) in
            XCTAssertEqual(response.success, true)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    func testAPICorrectFailureResponse() throws {
        try XCTSkipUnless(
        networkMonitor.isReachable,
        "Network connectivity needed for this test.")
        let promise = expectation(description: "Completion handler invoked")
        sut.requestWith(urlString: "http://api.openweathermap.org/data/2.5/weather?lat=17.6868&lon=83.2185", params: nil, model: ForeCastModel.self) { (response) in
            XCTAssertEqual(response.list?.count ?? 0, 0)
            XCTAssertEqual(response.message, "Invalid API key. Please see http://openweathermap.org/faq#error401 for more info.")
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    func testLocalCitiesSuccessResponse() throws {
        let promise = expectation(description: "Completion handler invoked")
        sut.fetchDataFromLocalJson(fileName: "DefaultCities", model: CityModel.self) { (response) in
            XCTAssertGreaterThan(response.list?.count ?? 0, 0)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    func testLocalCitiesWrongFileNameResponse() throws {
        let promise = expectation(description: "Completion handler invoked")
        sut.fetchDataFromLocalJson(fileName: "DefaultCitie", model: CityModel.self) { (response) in
            XCTAssertEqual(response.list?.count ?? 0, 0)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    override func tearDownWithError() throws {
        sut = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
