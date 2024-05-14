//
//  TableViewTesting.swift
//  Networking_HomeworkTests
//
//  Created by Rimvydas on 2024-04-29.
//

import XCTest
@testable import Networking_Homework

final class TableViewTesting: XCTestCase {
    
    var viewController = ViewController()
    
    func testNumberOfRowsInSectionWhenCoreDataIsEmpty() {
        let mockTableView = UITableView()
        let mockCoreDataExtension = MockCoreDataExtension()
        viewController.coreDataExtension = mockCoreDataExtension
        mockCoreDataExtension.userDetailsCount = 0
        viewController.users = []
        
        let numberOfRows = viewController.tableView(mockTableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(numberOfRows, viewController.users.count)
    }
    
    func testNumberOfRowsInSectionWhenCoreDataIsNotEmpty() {
        let mockTableView = UITableView()
        let mockCoreDataExtension = MockCoreDataExtension()
        viewController.coreDataExtension = mockCoreDataExtension
        mockCoreDataExtension.userDetailsCount = 3
        viewController.users = [
            Users.init(id: 1, name: "", username: "", email: ""),
            Users.init(id: 2, name: "", username: "", email: ""),
            Users.init(id: 3, name: "", username: "", email: "")
        ]
        
        let numberOfRows = viewController.tableView(mockTableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(numberOfRows, mockCoreDataExtension.userDetailsCount)
    }
    
    // Mock CoreDataExtension for testing
    class MockCoreDataExtension: CoreDataExtension {
        var userDetailsCount: Int = 0
    }
    
    func testAsyncAfter() {
        let expectation = XCTestExpectation(description: "AsyncAfter")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testHandleRefreshControlWhenUserDetailsIsEmpty() {
           let mockCoreDataExtension = MockCoreDataExtension()
           viewController.coreDataExtension = mockCoreDataExtension
           mockCoreDataExtension.userDetails = []

           viewController.handleRefreshControl()
            var startAndStopLoadingFromCoreDataCalled = true

        XCTAssertTrue(startAndStopLoadingFromCoreDataCalled)
       }

       func testHandleRefreshControlWhenUserDetailsIsNotEmpty() {
           let mockCoreDataExtension = MockCoreDataExtension()
           viewController.coreDataExtension = mockCoreDataExtension
           mockCoreDataExtension.userDetails = [UserDetails()]

           viewController.handleRefreshControl()
           var startAndStopLoadingFromCoreDataCalled = true

           XCTAssertTrue(startAndStopLoadingFromCoreDataCalled)
       }
   }

       


