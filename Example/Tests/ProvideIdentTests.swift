//
//  ProvideIdentTests.swift
//  provide_Example
//
//  Created by Kevin Munc on 09/19/18.
//  Copyright © 2018 Provide. All rights reserved.
//

import XCTest
import provide

class ProvideIdentTests: XCTestCase {
    
    // MARK: - Authenticate Tests
    
    func testAuthenticateSuccess() throws {
        let email = "valid@email.com"
        let theToken = "the-authentication.token"
        let responseDict = ["token" : ["token" : theToken]] // only a partial representation
        let responseData = try JSONSerialization.data(withJSONObject: responseDict, options: .prettyPrinted)
        let stub = StubApiClient()
        stub.postSuccessResult = responseData as AnyObject
        let exp = expectation(description: "Completion block was called")
        
        try ProvideIdent(stub).authenticate(email: email, password: "Soop3rSuhkyuur", successHandler: { (result) in
            self.expectedPass(exp)
        }, failureHandler: { (response, result, error) in
            self.unexpectedFail(exp)
        })
        
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                XCTAssertTrue(true, "There should not have been an error")
                XCTAssertNotNil(stub.mostRecentRequest)
                XCTAssertTrue(stub.mostRecentRequest!.debugDescription.contains(email))
                // FIXME: KeychainService access issue: XCTAssertEqual(KeychainService.shared.authToken, theToken, "The token should have been persisted")
            }
        }
    }
    
    func testAuthenticateFailure() throws {
        let email = "nope@noway.not"
        let stub = StubApiClient()
        stub.postShouldSucceed = false
        let exp = expectation(description: "Completion block was called")
        
        try ProvideIdent(stub).authenticate(email: email, password: "S3cr3tTurk3y!", successHandler: { (result) in
            self.unexpectedPass(exp)
        }, failureHandler: { (response, result, error) in
            self.expectedFail(exp)
        })
        
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                XCTAssertTrue(true, "There should not have been an error")
                XCTAssertNotNil(stub.mostRecentRequest)
                XCTAssertTrue(stub.mostRecentRequest!.debugDescription.contains(email))
            }
        }
    }
    
    // MARK: - Create Application Tests
    
    func testCreateApplicatoinSuccess() throws {
        let name = "Created by a Unit Test"
        let networkId = "guid for a uuid"
        let stub = StubApiClient()
        let exp = expectation(description: "Completion block was called")
        
        try ProvideIdent(stub).createApplication(name: name, networkId: networkId, successHandler: { (result) in
            self.expectedPass(exp)
        }, failureHandler: { (response, result, error) in
            self.unexpectedFail(exp)
        })
        
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                XCTAssertTrue(true, "There should not have been an error")
                XCTAssertNotNil(stub.mostRecentRequest)
                XCTAssertTrue(stub.mostRecentRequest!.debugDescription.contains(name))
                XCTAssertTrue(stub.mostRecentRequest!.debugDescription.contains(networkId))
            }
        }
    }
    
    func testCreateApplicationFailure() throws {
        let name = "Created by a Unit Test"
        let networkId = "guid for a uuid"
        let stub = StubApiClient()
        stub.postShouldSucceed = false
        let exp = expectation(description: "Completion block was called")
        
        try ProvideIdent(stub).createApplication(name: name, networkId: networkId, successHandler: { (result) in
            self.unexpectedPass(exp)
        }, failureHandler: { (response, result, error) in
            self.expectedFail(exp)
        })
        
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                XCTAssertTrue(true, "There should not have been an error")
                XCTAssertNotNil(stub.mostRecentRequest)
                XCTAssertTrue(stub.mostRecentRequest!.debugDescription.contains(name))
                XCTAssertTrue(stub.mostRecentRequest!.debugDescription.contains(networkId))
            }
        }
    }
    
}
