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
                                     "event_checkout_progress",
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
                                     "event_set_checkout_option",
                                     "event_share","event_signup",
                                     "event_spend_virtual_currency",
                                     "event_tutorial_begin",
                                     "event_tutorial_complete",
                                     "event_unlock_achievement",
                                     "event_view_item",
                                     "event_view_item_list",
                                     "event_view_search_results"]
        firebaseEventNames = [AnalyticsEventAddPaymentInfo,
                              AnalyticsEventAddShippingInfo,
                              AnalyticsEventAddToCart,
                              AnalyticsEventAddToWishlist,
                              AnalyticsEventAppOpen,
                              AnalyticsEventBeginCheckout,
                              AnalyticsEventCampaignDetails,
                              AnalyticsEventCheckoutProgress,
                              AnalyticsEventEarnVirtualCurrency,
                              AnalyticsEventEcommercePurchase,
                              AnalyticsEventGenerateLead,
                              AnalyticsEventJoinGroup,
                              AnalyticsEventLevelEnd,
                              AnalyticsEventLevelStart,
                              AnalyticsEventLevelUp,
                              AnalyticsEventLogin,
                              AnalyticsEventPostScore,
                              AnalyticsEventPresentOffer,
                              AnalyticsEventPurchase,
                              AnalyticsEventPurchaseRefund,
                              AnalyticsEventRefund,
                              AnalyticsEventRemoveFromCart,
                              AnalyticsEventSearch,
                              AnalyticsEventSelectContent,
                              AnalyticsEventSetCheckoutOption,
                              AnalyticsEventShare,
                              AnalyticsEventSignUp,
                              AnalyticsEventSpendVirtualCurrency,
                              AnalyticsEventTutorialBegin,
                              AnalyticsEventTutorialComplete,
                              AnalyticsEventUnlockAchievement,
                              AnalyticsEventViewItem,
                              AnalyticsEventViewItemList,
                              AnalyticsEventViewSearchResults]
        
        for (index, name) in acceptedTealiumEventNames.enumerated() {
            let actual = firebaseCommand.mapEvent(name)
            let expected = firebaseEventNames[index]
            XCTAssertEqual(expected, actual)
        }
        
    }
    
    func testFirebaseItems() {
        let payload = ["param_item_id": ["abc123", "xyz456"],
            "param_item_name": ["cool running shoes", "cool shirt"],
            "param_quantity": [1, 2],
            "param_item_category": ["shoes", "shirts"],
            "param_item_variant": ["abc-blue-123", "xyz-red-456"],
            "param_item_brand": ["acme", "roadrunner"],
            "param_price": [10.99, 14.99]]
        
        let expected = [["item_id": "abc123",
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
        "price": 14.99]]
        
        guard let actual = try? XCTUnwrap([FirebaseItem](from: payload)?.dictionaryArray) else {
            return
        }
        
        zip(actual, expected).forEach {
            XCTAssert(NSDictionary(dictionary: $0.0).isEqual(to:  $0.1))
        }
                
    }
}
