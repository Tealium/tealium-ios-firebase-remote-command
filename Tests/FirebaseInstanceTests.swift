//
//  FirebaseInstanceTests.swift
//  FirebaseTests
//
//  Created by Christina S on 7/12/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import XCTest
@testable import TealiumFirebase
import TealiumRemoteCommands

class FirebaseInstanceTests: XCTestCase {

    let firebaseInstance = MockFirebaseInstance()
    var firebaseCommand: FirebaseRemoteCommand!
    var remoteCommand: RemoteCommand!

    override func setUp() {
        firebaseCommand = FirebaseRemoteCommand(firebaseInstance: firebaseInstance)
    }

    override func tearDown() { }

    // MARK: Webview Remote Command Tests
    func testCreateAnalyticsConfigWithoutValues() {
        let expect = expectation(description: "firebase config should run")
        let payload: [String: Any] = ["command_name": "config"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.createAnalyticsConfigCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testCreateAnalyticsConfigWithValues() {
        let expect = expectation(description: "firebase config should run")
        let payload: [String: Any] = ["command_name": "config", "firebase_session_timeout_seconds": "60", "firebase_session_minimum_seconds": "30", "firebase_analytics_enabled": "true", "firebase_log_level": "max"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.createAnalyticsConfigCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testCreateAnalyticsConfigShouldNotRun() {
        let expect = expectation(description: "firebase config should not run")
        let payload: [String: Any] = ["command_name": "initialize"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(0, firebaseInstance.createAnalyticsConfigCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testLogEventWithParams() {
        let expect = expectation(description: "log event should run")
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "event_add_to_cart", "firebase_event_params":
                ["param_items": [
                    ["param_item_id": "abc123",
                        "param_price": 19.00,
                        "param_quantity": 1
                    ],
                    ["param_item_id": "abc123",
                        "param_price": 19.00,
                        "param_quantity": 1
                    ]
                        ]
            , "param_coupon": "summer2020", "param_campaign": "disney"]
        ]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testLogEventWithoutParams() {
        let expect = expectation(description: "log event should not run")
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "event_level_up"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSetScreenNameWithScreenValues() {
        let expect = expectation(description: "set screen name should run")
        let payload: [String: Any] = ["command_name": "setscreenname", "firebase_screen_name": "product_view", "firebase_screen_class": "ProductDetailViewController"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.setScreenNameCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSetScreenNameWithoutScreenValues() {
        let expect = expectation(description: "set screen name should not run")
        let payload: [String: Any] = ["command_name": "setscreenname"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(0, firebaseInstance.setScreenNameCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSetUserPropertyWithValues() {
        let expect = expectation(description: "set user property should run")
        let payload: [String: Any] = ["command_name": "setuserproperty", "firebase_property_name": "favorite_color", "firebase_property_value": "blue"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.setUserPropertyCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSetUserPropertyWithoutValues() {
        let expect = expectation(description: "set user property should not run")
        let payload: [String: Any] = ["command_name": "setuserproperty"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(0, firebaseInstance.setUserPropertyCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetUserPropertiesWithValues() {
        let expect = expectation(description: "set user property should run")
        let payload: [String: Any] = ["command_name": "setuserproperty", "firebase_property_name": ["favorite_color", "nickname"], "firebase_property_value": ["blue", "sparky"]]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(2, firebaseInstance.setUserPropertyCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSetUserIdWithUserId() {
        let expect = expectation(description: "set user id should run")
        let payload: [String: Any] = ["command_name": "setuserid", "firebase_user_id": "abc123"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.setUserIdCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSetUserIdWithoutUserId() {
        let expect = expectation(description: "set user id should not run")
        let payload: [String: Any] = ["command_name": "setuserid"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(0, firebaseInstance.setUserIdCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testMapParamsWhenTheyDontExistInLookup() {
                let expect = expectation(description: "set user id should not run")
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "ecommerce_purchase", "coupon": "couponCode", "currency": "AUD", "value": 19.99, "tax": 1.99, "shipping": 2.00, "transaction_id": "1232312321"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testMapParamsWhenTheyDoExistInLookup() {
                let expect = expectation(description: "set user id should not run")
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "event_ecommerce_purchase", "param_coupon": "couponCode", "param_currency": "AUD", "param_value": 19.99, "param_tax": 1.99, "param_shipping": 2.00, "param_transaction_id": "1232312321"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testInitiateConversionMeasurementWithValues() {
        let expect = expectation(description: "initiate conversion measurement should run")
        let payload: [String: Any] = ["command_name": "initiateconversionmeasurement", "param_email_address": "email@domain.com"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.initateConversionCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testInitiateConversionMeasurementWithoutValues() {
        let expect = expectation(description: "initiate conversion measurement should not run")
        let payload: [String: Any] = ["command_name": "initiateconversionmeasurement"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(0, firebaseInstance.initateConversionCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    // MARK: JSON Remote Command Tests
    func testCreateAnalyticsConfigWithoutValuesJSON() {
        let expect = expectation(description: "firebase config should run")
        let payload: [String: Any] = ["command_name": "config"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.createAnalyticsConfigCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testCreateAnalyticsConfigWithValuesJSON() {
        let expect = expectation(description: "firebase config should run")
        let payload: [String: Any] = ["command_name": "config", "firebase_session_timeout_seconds": "60", "firebase_session_minimum_seconds": "30", "firebase_analytics_enabled": "true", "firebase_log_level": "max"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.createAnalyticsConfigCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testCreateAnalyticsConfigShouldNotRunJSON() {
        let expect = expectation(description: "firebase config should not run")
        let payload: [String: Any] = ["command_name": "initialize"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(0, firebaseInstance.createAnalyticsConfigCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testLogEventWithParamsJSON() {
        let expect = expectation(description: "log event should run")
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "event_add_to_cart", "firebase_event_params":
                ["param_items": [
                    ["param_item_id": "abc123",
                        "param_price": 19.00,
                        "param_quantity": 1
                    ],
                    ["param_item_id": "abc123",
                        "param_price": 19.00,
                        "param_quantity": 1
                    ]
                        ]
            , "param_coupon": "summer2020", "param_campaign": "disney"]
        ]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testLogEventWithoutParamsJSON() {
        let expect = expectation(description: "log event should not run")
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "event_level_up"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSetScreenNameWithScreenValuesJSON() {
        let expect = expectation(description: "set screen name should run")
        let payload: [String: Any] = ["command_name": "setscreenname", "firebase_screen_name": "product_view", "firebase_screen_class": "ProductDetailViewController"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.setScreenNameCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSetScreenNameWithoutScreenValuesJSON() {
        let expect = expectation(description: "set screen name should not run")
        let payload: [String: Any] = ["command_name": "setscreenname"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(0, firebaseInstance.setScreenNameCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSetUserPropertyWithValuesJSON() {
        let expect = expectation(description: "set user property should run")
        let payload: [String: Any] = ["command_name": "setuserproperty", "firebase_property_name": "favorite_color", "firebase_property_value": "blue"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.setUserPropertyCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSetUserPropertyWithoutValuesJSON() {
        let expect = expectation(description: "set user property should not run")
        let payload: [String: Any] = ["command_name": "setuserproperty"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(0, firebaseInstance.setUserPropertyCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetUserPropertiesWithValuesJSON() {
        let expect = expectation(description: "set user property should run")
        let payload: [String: Any] = ["command_name": "setuserproperty", "firebase_property_name": ["favorite_color", "nickname"], "firebase_property_value": ["blue", "sparky"]]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(2, firebaseInstance.setUserPropertyCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSetUserIdWithUserIdJSON() {
        let expect = expectation(description: "set user id should run")
        let payload: [String: Any] = ["command_name": "setuserid", "firebase_user_id": "abc123"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.setUserIdCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSetUserIdWithoutUserIdJSON() {
        let expect = expectation(description: "set user id should not run")
        let payload: [String: Any] = ["command_name": "setuserid"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(0, firebaseInstance.setUserIdCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testMapParamsWhenTheyDontExistInLookupJSON() {
                let expect = expectation(description: "set user id should not run")
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "ecommerce_purchase", "coupon": "couponCode", "currency": "AUD", "value": 19.99, "tax": 1.99, "shipping": 2.00, "transaction_id": "1232312321"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testMapParamsWhenTheyDoExistInLookupJSON() {
        let expect = expectation(description: "set user id should not run")
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "event_ecommerce_purchase", "param_coupon": "couponCode", "param_currency": "AUD", "param_value": 19.99, "param_tax": 1.99, "param_shipping": 2.00, "param_transaction_id": "1232312321"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testStringItemsInPayloadJSON() {
        let expect = expectation(description: "set user id should not run")
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "event_add_to_cart", "items": ["param_item_id": "abc123", "param_item_category": "Shirts"]]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testArrayItemsInPayloadJSON() {
        let expect = expectation(description: "set user id should not run")
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "event_add_to_cart", "items": ["param_item_id": ["abc123"], "param_item_category": ["Shirts"]]]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testInitiateConversionMeasurementWithValuesJSON() {
        let expect = expectation(description: "initiate conversion measurement should run")
        let payload: [String: Any] = ["command_name": "initiateconversionmeasurement", "param_email_address": "email@domain.com"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.initateConversionCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testInitiateConversionMeasurementWithoutValuesJSON() {
        let expect = expectation(description: "initiate conversion measurement should not run")
        let payload: [String: Any] = ["command_name": "initiateconversionmeasurement"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(0, firebaseInstance.initateConversionCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testCustomEventParameters() {
        let expect = expectation(description: "set user id should not run")
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "mobile_hoteldetails", "event": ["param_city": "San Diego","param_productdisplaytype": "Opaque","param_numrooms": 1,"param_state": "CA","param_numadults": 2,"param_country": "US","param_numchildren": 0,"param_checkout_yyyymmdd": "2021-05-13","param_checkin_yyyymmdd": "2021-05-12","param_dta": 0]]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetDefaultParameters() {
        let expect = expectation(description: "set user id should not run")
        let defaultParameters: [String: Any]? = ["defaultParam1": "defaultValue1"]
        let payload: [String: Any] = ["command_name": "setdefaultparameters", "default": defaultParameters as Any]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertNotNil(firebaseInstance.defaultParameters)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetDefaultParametersFromTag() {
        let expect = expectation(description: "set user id should not run")
        let defaultParameters: [String: Any]? = ["defaultParam1": "defaultValue1"]
        let payload: [String: Any] = ["command_name": "setdefaultparameters", "firebase_default_params": defaultParameters as Any]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .JSON, commandId: "firebase", payload: payload) {
            firebaseCommand.completion(response)
            XCTAssertNotNil(firebaseInstance.defaultParameters)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

}
