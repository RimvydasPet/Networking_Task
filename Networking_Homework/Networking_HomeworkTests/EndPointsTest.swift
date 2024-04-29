//
//  EndPointsTest.swift
//  Networking_HomeworkTests
//
//  Created by Rimvydas on 2024-04-29.
//

import XCTest
@testable import Networking_Homework

final class EndPointsTest: XCTestCase {
    
    func testMainUrlString() {
        // Arrange
        let expectedMainUrlString = "https://jsonplaceholder.typicode.com"
        
        // Act
        let mainUrlString = EndPoints.mainUrlString
        
        // Assert
        XCTAssertEqual(mainUrlString, expectedMainUrlString)
    }
    
    func testPostsEndpoint() {
        let expectedPostsEndpoint = "https://jsonplaceholder.typicode.com/posts"
        
        let postsEndpoint = EndPoints.postsEndpoint
        
        XCTAssertEqual(postsEndpoint, expectedPostsEndpoint)
    }
    
    func testUsersEndpoint() {
        let expectedUsersEndpoint = "https://jsonplaceholder.typicode.com/users"
        
        let usersEndpoint = EndPoints.usersEndpoint
        
        XCTAssertEqual(usersEndpoint, expectedUsersEndpoint)
    }
}
