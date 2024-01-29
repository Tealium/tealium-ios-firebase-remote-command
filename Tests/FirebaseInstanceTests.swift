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
    
    func testCreateAnalyticsConfigWithoutValues() {
        let payload: [String: Any] = ["command_name": "config"]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, firebaseInstance.createAnalyticsConfigCallCount)
    }
    
    func testCreateAnalyticsConfigWithValues() {
        let payload: [String: Any] = ["command_name": "config",
                                      "firebase_session_timeout_seconds": "60",
                                      "firebase_session_minimum_seconds": "30",
                                      "firebase_analytics_enabled": "true",
                                      "firebase_log_level": "max"]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, firebaseInstance.createAnalyticsConfigCallCount)
    }
    
    func testCreateAnalyticsConfigShouldNotRun() {
        let payload: [String: Any] = ["command_name": "initialize"]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, firebaseInstance.createAnalyticsConfigCallCount)
    }
    
    func testLogEventWithParams() {
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
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
    }
    
    func testLogEventWithoutParams() {
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "event_level_up"]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
    }
    
    func testSetScreenNameWithScreenValues() {
        let payload: [String: Any] = ["command_name": "setscreenname", "firebase_screen_name": "product_view", "firebase_screen_class": "ProductDetailViewController"]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, firebaseInstance.setScreenNameCallCount)
    }
    
    func testSetScreenNameWithoutScreenValues() {
        let payload: [String: Any] = ["command_name": "setscreenname"]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, firebaseInstance.setScreenNameCallCount)
    }
    
    func testSetUserPropertyWithValues() {
        let payload: [String: Any] = ["command_name": "setuserproperty", "firebase_property_name": "favorite_color", "firebase_property_value": "blue"]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, firebaseInstance.setUserPropertyCallCount)
    }
    
    func testSetUserPropertyWithoutValues() {
        let payload: [String: Any] = ["command_name": "setuserproperty"]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, firebaseInstance.setUserPropertyCallCount)
    }
    
    func testSetUserPropertiesWithValues() {
        let payload: [String: Any] = ["command_name": "setuserproperty", "firebase_property_name": ["favorite_color", "nickname"], "firebase_property_value": ["blue", "sparky"]]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(2, firebaseInstance.setUserPropertyCallCount)
    }
    
    func testSetUserIdWithUserId() {
        let payload: [String: Any] = ["command_name": "setuserid", "firebase_user_id": "abc123"]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, firebaseInstance.setUserIdCallCount)
    }
    
    func testSetUserIdWithoutUserId() {
        let payload: [String: Any] = ["command_name": "setuserid"]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, firebaseInstance.setUserIdCallCount)
    }
    
    func testMapParamsWhenTheyDontExistInLookup() {
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "ecommerce_purchase", "coupon": "couponCode", "currency": "AUD", "value": 19.99, "tax": 1.99, "shipping": 2.00, "transaction_id": "1232312321"]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
    }
    
    func testMapParamsWhenTheyDoExistInLookup() {
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "event_ecommerce_purchase", "param_coupon": "couponCode", "param_currency": "AUD", "param_value": 19.99, "param_tax": 1.99, "param_shipping": 2.00, "param_transaction_id": "1232312321"]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
    }
    
    func testInitiateConversionMeasurementWithValues() {
        let payload: [String: Any] = ["command_name": "initiateconversionmeasurement", "param_email_address": "email@domain.com"]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, firebaseInstance.initateConversionCount)
    }
    
    func testInitiateConversionMeasurementWithoutValues() {
        let payload: [String: Any] = ["command_name": "initiateconversionmeasurement"]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, firebaseInstance.initateConversionCount)
    }
    
    func testStringItemsInPayload() {
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "event_add_to_cart", "items": ["param_item_id": "abc123", "param_item_category": "Shirts"]]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
    }
    
    func testArrayItemsInPayloadJSON() {
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "event_add_to_cart", "items": ["param_item_id": ["abc123"], "param_item_category": ["Shirts"]]]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
    }
    
    func testCustomEventParameters() {
        let payload: [String: Any] = ["command_name": "logevent", "firebase_event_name": "mobile_hoteldetails", "event": ["param_city": "San Diego","param_productdisplaytype": "Opaque","param_numrooms": 1,"param_state": "CA","param_numadults": 2,"param_country": "US","param_numchildren": 0,"param_checkout_yyyymmdd": "2021-05-13","param_checkin_yyyymmdd": "2021-05-12","param_dta": 0]]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, firebaseInstance.logEventWithParamsCallCount)
    }
    
    func testSetDefaultParameters() {
        let defaultParameters: [String: Any]? = ["defaultParam1": "defaultValue1"]
        let payload: [String: Any] = ["command_name": "setdefaultparameters", "default": defaultParameters as Any]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertNotNil(firebaseInstance.defaultParameters)
    }

    func testSetConsent() {
        let consentSettings = ["ad_personalization": "granted",
                               "ad_storage": "granted",
                               "analytics_storage": "denied",
                               "ad_user_data": "denied"]
        let payload: [String: Any] = ["command_name": "setconsent", "firebase_consent_settings": consentSettings]
        firebaseCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(consentSettings, firebaseInstance.consentSettings)
    }
}
