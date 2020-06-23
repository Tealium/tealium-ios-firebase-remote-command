//
//  FirebaseCommandTests.swift
//  FirebaseTests
//
//  Created by Christina S on 7/12/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import XCTest
@testable import TealiumFirebase
@testable import Firebase

class FirebaseCommandTests: XCTestCase {

    var acceptedLogLevels = [String]()
    var firebaseLogLevels = [FirebaseLoggerLevel]()
    
    var acceptedTealiumEventNames = [String]()
    var firebaseEventNames = [String]()
    
    var acceptedTealiumVariableNames = [String]()
    var firebaseParameterNames = [String]()
    
    var mockFirebaseTracker = MockFirebaseTracker()
    var firebaseCommand: FirebaseRemoteCommand!
    
    override func setUp() {
        firebaseCommand = FirebaseRemoteCommand(firebaseTracker: mockFirebaseTracker)
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
    
    func testMapParam() {
        acceptedTealiumVariableNames = ["param_achievement_id",
                                        "param_ad_network_click_id",
                                        "param_affiliation",
                                        "param_cp1",
                                        "param_campaign",
                                        "param_character",
                                        "param_checkout_option",
                                        "param_checkout_step",
                                        "param_content",
                                        "param_content_type",
                                        "param_coupon",
                                        "param_creative_name",
                                        "param_creative_slot",
                                        "param_currency",
                                        "param_destination",
                                        "param_end_date",
                                        "param_flight_number",
                                        "param_group_id",
                                        "param_index",
                                        "param_item_brand",
                                        "param_item_category",
                                        "param_item_id",
                                        "param_item_list",
                                        "param_item_location_id",
                                        "param_item_name",
                                        "param_item_variant",
                                        "param_level",
                                        "param_location",
                                        "param_medium",
                                        "param_number_nights",
                                        "param_number_pax",
                                        "param_number_rooms",
                                        "param_origin",
                                        "param_price",
                                        "param_quantity",
                                        "param_score",
                                        "param_search_term",
                                        "param_shipping",
                                        "param_signup_method",
                                        "param_source",
                                        "param_start_date",
                                        "param_tax",
                                        "param_term",
                                        "param_transaction_id",
                                        "param_travel_class",
                                        "param_value",
                                        "param_virtual_currency_name",
                                        "param_user_signup_method"]
        firebaseParameterNames = [AnalyticsParameterAchievementID,
                                  AnalyticsParameterAdNetworkClickID,
                                  AnalyticsParameterAffiliation,
                                  AnalyticsParameterCP1,
                                  AnalyticsParameterCampaign,
                                  AnalyticsParameterCharacter,
                                  AnalyticsParameterCheckoutOption,
                                  AnalyticsParameterCheckoutStep,
                                  AnalyticsParameterContent,
                                  AnalyticsParameterContentType,
                                  AnalyticsParameterCoupon,
                                  AnalyticsParameterCreativeName,
                                  AnalyticsParameterCreativeSlot,
                                  AnalyticsParameterCurrency,
                                  AnalyticsParameterDestination,
                                  AnalyticsParameterEndDate,
                                  AnalyticsParameterFlightNumber,
                                  AnalyticsParameterGroupID,
                                  AnalyticsParameterIndex,
                                  AnalyticsParameterItemBrand,
                                  AnalyticsParameterItemCategory,
                                  AnalyticsParameterItemID,
                                  AnalyticsParameterItemList,
                                  AnalyticsParameterItemLocationID,
                                  AnalyticsParameterItemName,
                                  AnalyticsParameterItemVariant,
                                  AnalyticsParameterLevel,
                                  AnalyticsParameterLocation,
                                  AnalyticsParameterMedium,
                                  AnalyticsParameterNumberOfNights,
                                  AnalyticsParameterNumberOfPassengers,
                                  AnalyticsParameterNumberOfRooms,
                                  AnalyticsParameterOrigin,
                                  AnalyticsParameterPrice,
                                  AnalyticsParameterQuantity,
                                  AnalyticsParameterScore,
                                  AnalyticsParameterSearchTerm,
                                  AnalyticsParameterShipping,
                                  AnalyticsParameterSignUpMethod,
                                  AnalyticsParameterSource,
                                  AnalyticsParameterStartDate,
                                  AnalyticsParameterTax,
                                  AnalyticsParameterTerm,
                                  AnalyticsParameterTransactionID,
                                  AnalyticsParameterTravelClass,
                                  AnalyticsParameterValue,
                                  AnalyticsParameterVirtualCurrencyName,
                                  AnalyticsUserPropertySignUpMethod]
        
        for (index, parameterName) in acceptedTealiumVariableNames.enumerated() {
            let actual = FirebaseRemoteCommand.mapParam(parameterName)
            let expected = firebaseParameterNames[index]
            XCTAssertEqual(expected, actual)
        }
        
    }
    
    func testMapParamsWithAllInMappings() {
        let payload: [String: Any] = ["param_value": 19.99, "param_transaction_id": "ord1222", "param_currency": "USD", "param_shipping": 2.00, "param_tax": 1.00, "param_coupon": "summer", "param_item_id": ["abc123", "def456"], "param_item_name": ["coolthing", "verycoolthing"], "param_item_variant": ["xyz-89-01", "xyz-99-02"], "param_item_brand": ["acme", "roadrunner"], "param_item_category": ["category1", "category2"]]
        
        let expected: [String: Any] = ["value": 19.99, "transaction_id": "ord1222", "currency": "USD", "shipping": 2.00, "tax": 1.00, "coupon": "summer", "item_id": ["abc123", "def456"], "item_name": ["coolthing", "verycoolthing"], "item_variant": ["xyz-89-01", "xyz-99-02"], "item_brand": ["acme", "roadrunner"], "item_category": ["category1", "category2"]]
        
        let actual = payload.mapParams()
        XCTAssert(NSDictionary(dictionary: actual).isEqual(to: expected))
    }
    
    func testMapParamsWithAllNotInMappings() {
        let payload: [String: Any] = ["value": 19.99, "transaction_id": "ord1222", "currency": "USD", "shipping": 2.00, "tax": 1.00, "coupon": "summer", "item_id": ["abc123", "def456"], "item_name": ["coolthing", "verycoolthing"], "item_variant": ["xyz-89-01", "xyz-99-02"], "item_brand": ["acme", "roadrunner"], "item_category": ["category1", "category2"]]
        
        let expected: [String: Any] = ["value": 19.99, "transaction_id": "ord1222", "currency": "USD", "shipping": 2.00, "tax": 1.00, "coupon": "summer", "item_id": ["abc123", "def456"], "item_name": ["coolthing", "verycoolthing"], "item_variant": ["xyz-89-01", "xyz-99-02"], "item_brand": ["acme", "roadrunner"], "item_category": ["category1", "category2"]]
        
        let actual = payload.mapParams()
        XCTAssert(NSDictionary(dictionary: actual).isEqual(to: expected))
    }
    
    func testMapParamsWithSomeInMappingsSomeNot() {
        let payload: [String: Any] = ["param_value": 19.99, "transaction_id": "ord1222", "param_currency": "USD", "param_shipping": 2.00, "param_tax": 1.00, "param_coupon": "summer", "item_id": ["abc123", "def456"], "param_item_name": ["coolthing", "verycoolthing"], "item_variant": ["xyz-89-01", "xyz-99-02"], "item_brand": ["acme", "roadrunner"], "param_item_category": ["category1", "category2"]]
        
        let expected: [String: Any] = ["value": 19.99, "transaction_id": "ord1222", "currency": "USD", "shipping": 2.00, "tax": 1.00, "coupon": "summer", "item_id": ["abc123", "def456"], "item_name": ["coolthing", "verycoolthing"], "item_variant": ["xyz-89-01", "xyz-99-02"], "item_brand": ["acme", "roadrunner"], "item_category": ["category1", "category2"]]
        
        let actual = payload.mapParams()
        XCTAssert(NSDictionary(dictionary: actual).isEqual(to: expected))
    }

}
