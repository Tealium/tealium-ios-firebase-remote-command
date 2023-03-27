//
//  FirebaseCommandTests.swift
//  FirebaseTests
//
//  Created by Christina S on 7/12/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import XCTest
@testable import TealiumFirebase
import FirebaseCore
import FirebaseAnalytics

class FirebaseCommandTests: XCTestCase {

    var acceptedLogLevels = [String]()
    var firebaseLogLevels = [FirebaseLoggerLevel]()
    
    var acceptedTealiumEventNames = [String]()
    var firebaseEventNames = [String]()
    
    var acceptedTealiumVariableNames = [String]()
    var firebaseParameterNames = [String]()
    
    var mockFirebaseTracker = MockFirebaseInstance()
    var firebaseCommand: FirebaseRemoteCommand!
    
    override func setUp() {
        firebaseCommand = FirebaseRemoteCommand(firebaseInstance: mockFirebaseTracker)
    }

    override func tearDown() { }

    func testParseLogLevel() {
        acceptedLogLevels = ["min", "max", "error", "debug", "notice", "warning", "info"]
        firebaseLogLevels = [.min, .max, .error, .debug, .notice, .warning, .info, .min]
        
        for (index, logLevel) in acceptedLogLevels.enumerated() {
            let actual = firebaseCommand.parseLogLevel(logLevel)
            let expected = firebaseLogLevels[index]
            XCTAssertEqual(expected, actual)
        }
        
    }
    
    func testMapEventNames() {
        acceptedTealiumEventNames = ["event_add_payment_info",
                                     "event_add_shipping_info",
                                     "event_add_to_cart",
                                     "event_add_to_wishlist",
                                     "event_app_open",
                                     "event_begin_checkout",
                                     "event_campaign_details",
                                     "event_earn_virtual_currency",
                                     "event_ecommerce_purchase",
                                     "event_generate_lead",
                                     "event_join_group",
                                     "event_level_end",
                                     "event_level_start",
                                     "event_level_up",
                                     "event_login",
                                     "event_post_score",
                                     "event_present_offer",
                                     "event_purchase",
                                     "event_purchase_refund",
                                     "event_refund",
                                     "event_remove_cart",
                                     "event_search",
                                     "event_select_content",
                                     "event_share","event_signup",
                                     "event_spend_virtual_currency",
                                     "event_tutorial_begin",
                                     "event_tutorial_complete",
                                     "event_unlock_achievement",
                                     "event_view_item",
                                     "event_view_item_list",
                                     "event_view_search_results"]
        firebaseParameterNames = [AnalyticsEventAddPaymentInfo,
                              AnalyticsEventAddShippingInfo,
                              AnalyticsEventAddToCart,
                              AnalyticsEventAddToWishlist,
                              AnalyticsEventAppOpen,
                              AnalyticsEventBeginCheckout,
                              AnalyticsEventCampaignDetails,
                              AnalyticsEventEarnVirtualCurrency,
                              AnalyticsEventPurchase,
                              AnalyticsEventGenerateLead,
                              AnalyticsEventJoinGroup,
                              AnalyticsEventLevelEnd,
                              AnalyticsEventLevelStart,
                              AnalyticsEventLevelUp,
                              AnalyticsEventLogin,
                              AnalyticsEventPostScore,
                              AnalyticsEventViewPromotion,
                              AnalyticsEventPurchase,
                              AnalyticsEventRefund,
                              AnalyticsEventRefund,
                              AnalyticsEventRemoveFromCart,
                              AnalyticsEventSearch,
                              AnalyticsEventSelectContent,
                              AnalyticsEventShare,
                              AnalyticsEventSignUp,
                              AnalyticsEventSpendVirtualCurrency,
                              AnalyticsEventTutorialBegin,
                              AnalyticsEventTutorialComplete,
                              AnalyticsEventUnlockAchievement,
                              AnalyticsEventViewItem,
                              AnalyticsEventViewItemList,
                              AnalyticsEventViewSearchResults]
        
        for (index, name) in acceptedTealiumVariableNames.enumerated() {
            let actual = firebaseCommand.mapEvent(name)
            let expected = firebaseParameterNames[index]
            XCTAssertEqual(expected, actual)
        }
        
    }
    
    func testMapParams() {
        acceptedTealiumVariableNames = [ "param_achievement_id",
                                      "param_ad_network_click_id",
                                      "param_affiliation",
                                      "param_cp1",
                                      "param_campaign",
                                      "param_character",
                                      "param_content",
                                      "param_content_type",
                                      "param_coupon",
                                      "param_creative_name",
                                      "param_creative_slot",
                                      "param_currency",
                                      "param_destination",
                                      "param_discount",
                                      "param_end_date",
                                      "param_extend_session",
                                      "param_flight_number",
                                      "param_group_id",
                                      "param_index",
                                      "param_item_brand",
                                      "param_item_category",
                                      "param_item_id",
                                      "param_item_list",
                                      "param_item_list_id",
                                      "param_item_list_name",
                                      "param_item_location_id",
                                      "param_item_name",
                                      "param_item_variant",
                                      "param_level",
                                      "param_level_name",
                                      "param_location",
                                      "param_location_id",
                                      "param_medium",
                                      "param_method",
                                      "param_number_nights",
                                      "param_number_pax",
                                      "param_number_rooms",
                                      "param_origin",
                                      "param_payment_type",
                                      "param_price",
                                      "param_promotion_id",
                                      "param_promotion_name",
                                      "param_quantity",
                                      "param_score",
                                      "param_search_term",
                                      "param_shipping",
                                      "param_shipping_tier",
                                      "param_signup_method",
                                      "param_source",
                                      "param_start_date",
                                      "param_success",
                                      "param_tax",
                                      "param_term",
                                      "param_transaction_id",
                                      "param_travel_class",
                                      "param_value",
                                      "param_virtual_currency_name",
                                      "param_user_signup_method"]
        firebaseEventNames = [AnalyticsParameterAchievementID,
            AnalyticsParameterAdNetworkClickID,
            AnalyticsParameterAffiliation,
            AnalyticsParameterCP1,
            AnalyticsParameterCampaign,
            AnalyticsParameterCharacter,
            AnalyticsParameterContent,
            AnalyticsParameterContentType,
            AnalyticsParameterCoupon,
            AnalyticsParameterCreativeName,
            AnalyticsParameterCreativeSlot,
            AnalyticsParameterCurrency,
            AnalyticsParameterDestination,
            AnalyticsParameterDiscount,
            AnalyticsParameterEndDate,
            AnalyticsParameterExtendSession,
            AnalyticsParameterFlightNumber,
            AnalyticsParameterGroupID,
            AnalyticsParameterIndex,
            AnalyticsParameterItemBrand,
            AnalyticsParameterItemCategory,
            AnalyticsParameterItemID,
            AnalyticsParameterItemListName,
            AnalyticsParameterItemListID,
            AnalyticsParameterItemListName,
            AnalyticsParameterLocationID,
            AnalyticsParameterItemName,
            AnalyticsParameterItemVariant,
            AnalyticsParameterLevel,
            AnalyticsParameterLevelName,
            AnalyticsParameterLocation,
            AnalyticsParameterLocationID,
            AnalyticsParameterMedium,
            AnalyticsParameterMethod,
            AnalyticsParameterNumberOfNights,
            AnalyticsParameterNumberOfPassengers,
            AnalyticsParameterNumberOfRooms,
            AnalyticsParameterOrigin,
            AnalyticsParameterPaymentType,
            AnalyticsParameterPrice,
            AnalyticsParameterPromotionID,
            AnalyticsParameterPromotionName,
            AnalyticsParameterQuantity,
            AnalyticsParameterScore,
            AnalyticsParameterSearchTerm,
            AnalyticsParameterShipping,
            AnalyticsParameterShippingTier,
            AnalyticsParameterMethod,
            AnalyticsParameterSource,
            AnalyticsParameterStartDate,
            AnalyticsParameterSuccess,
            AnalyticsParameterTax,
            AnalyticsParameterTerm,
            AnalyticsParameterTransactionID,
            AnalyticsParameterTravelClass,
            AnalyticsParameterValue,
            AnalyticsParameterVirtualCurrencyName,
            AnalyticsUserPropertySignUpMethod]
        
        for (index, name) in acceptedTealiumEventNames.enumerated() {
            let actual = firebaseCommand.mapEvent(name)
            let expected = firebaseEventNames[index]
            XCTAssertEqual(expected, actual)
        }
        
    }
    
    func testMapParamsWithCustom() {
        acceptedTealiumVariableNames = ["param_achievement_id",
                                      "param_ad_network_click_id",
                                      "param_affiliation",
                                      "param_cp1", "custom_param_1"]
        firebaseEventNames = [AnalyticsParameterAchievementID,
            AnalyticsParameterAdNetworkClickID,
            AnalyticsParameterAffiliation,
            AnalyticsParameterCP1, "custom_param_1"]
        
        for (index, name) in acceptedTealiumEventNames.enumerated() {
            let actual = firebaseCommand.mapEvent(name)
            let expected = firebaseEventNames[index]
            XCTAssertEqual(expected, actual)
        }
    }
    
    func testItemsFromPayloadTag() {
        let payload = ["items": [
                        "param_item_id": ["abc123","xyz456"],
                        "param_item_name": ["cool running shoes", "cool shirt"],
                        "param_quantity": [1, 2],
                        "param_item_category": ["shoes", "shirts"],
                        "param_item_variant": ["abc-blue-123", "xyz-red-456"],
                        "param_item_brand": ["acme", "roadrunner"],
                        "param_price": [10.99, 14.99]]]
        
        let expected: [String: Any] = ["items": [
                        ["item_id": "abc123",
                            "item_name": "cool running shoes",
                            "quantity": 1,
                            "item_category": "shoes",
                            "item_variant": "abc-blue-123",
                            "item_brand": "acme",
                            "price": 10.99],
                        ["item_id": "xyz456",
                            "item_name": "cool shirt",
                            "quantity": 2,
                            "item_category": "shirts",
                            "item_variant": "xyz-red-456",
                            "item_brand": "roadrunner",
                            "price": 14.99]]]
        
        let actual = firebaseCommand.items(from: payload)
        
        XCTAssertTrue(NSDictionary(dictionary: actual).isEqual(to:  expected))
        
    }
    
    func testItemsWithCustom() {
        let payload = ["items": [
                        "param_item_id": ["abc123","xyz456"],
                        "param_item_name": ["cool running shoes", "cool shirt"],
                        "param_quantity": [1, 2],
                        "param_item_category": ["shoes", "shirts"],
                        "param_item_variant": ["abc-blue-123", "xyz-red-456"],
                        "param_item_brand": ["acme", "roadrunner"],
                        "param_price": [10.99, 14.99],
                        "custom_param_1": ["test": "this"]]]
        
        let expected: [String: Any] = ["items": [
                        ["item_id": "abc123",
                            "item_name": "cool running shoes",
                            "quantity": 1,
                            "item_category": "shoes",
                            "item_variant": "abc-blue-123",
                            "item_brand": "acme",
                            "price": 10.99],
                        ["item_id": "xyz456",
                            "item_name": "cool shirt",
                            "quantity": 2,
                            "item_category": "shirts",
                            "item_variant": "xyz-red-456",
                            "item_brand": "roadrunner",
                            "price": 14.99]]]
        
        let actual = firebaseCommand.items(from: payload)
        XCTAssertTrue(NSDictionary(dictionary: actual).isEqual(to:  expected))
    }
    
    func testItemsWhenProductVariablesNotArray() {
        let payload = ["items": [
                        "param_item_id": "abc123",
                        "param_item_name": "cool running shoes",
                        "param_quantity": 1,
                        "param_item_category": "shoes",
                        "param_item_variant": "abc-blue-123",
                        "param_item_brand": "acme",
                        "param_price": 10.99,
                        "custom_param_1": "test"]]
        
        let expected: [String: Any] = ["items": [
                        ["item_id": "abc123",
                            "item_name": "cool running shoes",
                            "quantity": 1,
                            "item_category": "shoes",
                            "item_variant": "abc-blue-123",
                            "item_brand": "acme",
                            "price": 10.99]]]
        
        let actual = firebaseCommand.items(from: payload)
        XCTAssertTrue(NSDictionary(dictionary: actual).isEqual(to:  expected))
    }
    
    func testItemsWhithValidCustomParameter() {
        let payload = ["items": [
                        "param_item_id": "abc123",
                        "param_item_name": "cool running shoes",
                        "param_quantity": 1,
                        "param_item_category": "shoes",
                        "param_item_variant": "abc-blue-123",
                        "param_item_brand": "acme",
                        "param_price": 10.99,
                        "param_item_custom": "valid",
                        "custom_param": "invalid",]]
        
        let expected: [String: Any] = ["items": [
                        ["item_id": "abc123",
                            "item_name": "cool running shoes",
                            "quantity": 1,
                            "item_category": "shoes",
                            "item_variant": "abc-blue-123",
                            "item_brand": "acme",
                            "price": 10.99,
                            "param_item_custom": "valid"]]]
        
        let actual = firebaseCommand.items(from: payload)
        XCTAssertTrue(NSDictionary(dictionary: actual).isEqual(to:  expected))
    }
    func testPerformanceItemsWhenProductVariablesNotArray() {
            let count = 1000
            let payload = ["items": [
                            "param_item_id": Array(repeating: "abc123", count: count),
                            "param_item_name": Array(repeating: "cool running shoes", count: count),
                            "param_quantity": Array(repeating: 1, count: count),
                            "param_item_category": Array(repeating: "shoes", count: count),
                            "param_item_variant": Array(repeating: "abc-blue-123", count: count),
                            "param_item_brand": Array(repeating: "acme", count: count),
                            "param_price": Array(repeating: 10.99, count: count)]]
            
            let expected: [String: Any] = ["items": Array(repeating:
                            ["item_id": "abc123",
                                "item_name": "cool running shoes",
                                "quantity": 1,
                                "item_category": "shoes",
                                "item_variant": "abc-blue-123",
                                "item_brand": "acme",
                             "price": 10.99], count: count)]
            measure {
                let _ = firebaseCommand.items(from: payload)
            }
            
    //        XCTAssertTrue(NSDictionary(dictionary: actual).isEqual(to:  expected))
        }
}
