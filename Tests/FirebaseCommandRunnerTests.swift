//
//  FirebaseTests.swift
//  FirebaseTests
//
//  Created by Christina Sund on 7/12/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import XCTest
@testable import TealiumFirebase
import TealiumRemoteCommands

class FirebaseCommandRunnerTests: XCTestCase {

    let firebaseCommandRunner = MockFirebaseCommandRunner()
    var firebaseCommand: FirebaseCommand!
    var remoteCommand: TealiumRemoteCommand!
    
    override func setUp() {
        firebaseCommand = FirebaseCommand(firebaseCommandRunner: firebaseCommandRunner)
        remoteCommand = firebaseCommand.remoteCommand()
    }

    override func tearDown() { }

    func createRemoteCommandResponse(commandId: String, payload: [String: Any]) -> TealiumRemoteCommandResponse? {
        let responseDescription = HttpTestHelpers.httpRequestDescription(commandId: commandId, config: [:], payload: payload)
        if let description = responseDescription {
            return TealiumRemoteCommandResponse(urlString: description)
        }
        XCTFail("Could not create Remote Command Response description from stubs provided")
        return nil
    }
    
    func testCreateAnalyticsConfigWithoutValues() {
        let expect = expectation(description: "firebase config should run")
        let payload: [String: Any] = ["command_name": "config"]
        if let response = createRemoteCommandResponse(commandId: "firebase", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, firebaseCommandRunner.createAnalyticsConfigCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testCreateAnalyticsConfigWithValues() {
        let expect = expectation(description: "firebase config should run")
        let payload: [String: Any] = ["command_name": "config", "firebase_session_timeout_seconds": "60", "firebase_session_minimum_seconds": "30", "firebase_analytics_enabled": "true", "firebase_log_level": "max"]
        if let response = createRemoteCommandResponse(commandId: "firebase", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, firebaseCommandRunner.createAnalyticsConfigCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testCreateAnalyticsConfigShouldNotRun() {
        let expect = expectation(description: "firebase config should not run")
        let payload: [String: Any] = ["command_name": "initialize"]
        if let response = createRemoteCommandResponse(commandId: "firebase", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(0, firebaseCommandRunner.createAnalyticsConfigCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testLogEventWithParams() {
        let expect = expectation(description: "log event should run")
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "add_to_cart", "firebase_event_params": ["param_item_id": ["abc123"], "param_price": ["19.00"], "param_quantity": ["1"]]]
        if let response = createRemoteCommandResponse(commandId: "firebase", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, firebaseCommandRunner.logEventCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testLogEventWithoutParams() {
        let expect = expectation(description: "log event should not run")
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "event_level_up"]
        if let response = createRemoteCommandResponse(commandId: "firebase", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(0, firebaseCommandRunner.logEventCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetScreenNameWithScreenValues() {
        let expect = expectation(description: "set screen name should run")
        let payload: [String: Any] = ["command_name": "setscreenname", "firebase_screen_name": "product_view", "firebase_screen_class": "ProductDetailViewController"]
        if let response = createRemoteCommandResponse(commandId: "firebase", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, firebaseCommandRunner.setScreenNameCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetScreenNameWithoutScreenValues() {
        let expect = expectation(description: "set screen name should not run")
        let payload: [String: Any] = ["command_name": "setscreenname"]
        if let response = createRemoteCommandResponse(commandId: "firebase", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(0, firebaseCommandRunner.setScreenNameCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetUserPropertyWithValues() {
        let expect = expectation(description: "set user property should run")
        let payload: [String: Any] = ["command_name": "setuserproperty", "firebase_property_name": "favorite_color", "firebase_property_value": "blue"]
        if let response = createRemoteCommandResponse(commandId: "firebase", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, firebaseCommandRunner.setUserPropertyCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetUserPropertyWithoutValues() {
        let expect = expectation(description: "set user property should not run")
        let payload: [String: Any] = ["command_name": "setuserproperty"]
        if let response = createRemoteCommandResponse(commandId: "firebase", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(0, firebaseCommandRunner.setUserPropertyCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetUserIdWithUserId() {
        let expect = expectation(description: "set user id should run")
        let payload: [String: Any] = ["command_name": "setuserid", "firebase_user_id": "abc123"]
        if let response = createRemoteCommandResponse(commandId: "firebase", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, firebaseCommandRunner.setUserIdCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetUserIdWithoutUserId() {
        let expect = expectation(description: "set user id should not run")
        let payload: [String: Any] = ["command_name": "setuserid"]
        if let response = createRemoteCommandResponse(commandId: "firebase", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(0, firebaseCommandRunner.setUserIdCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

}
