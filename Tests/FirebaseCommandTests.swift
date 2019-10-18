//
//  FirebaseCommandTests.swift
//  FirebaseTests
//
//  Created by Christina Sund on 7/12/19.
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
    var firebaseCommand: FirebaseCommand!
    
    override func setUp() {
        firebaseCommand = FirebaseCommand(firebaseTracker: mockFirebaseTracker)
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
        acceptedTealiumEventNames = ["add_payment_info",
                                     "add_to_cart",
                                     "add_to_wishlist",
                                     "app_open",
                                     "event_begin_checkout",
                                     "event_campaign_details",
                                     "event_checkout_progress",
                                     "event_earn_virtual_currency",
                                     "event_ecommerce_purchase",
                                     "event_generate_lead",
                                     "event_join_group",
                                     "event_level_up",
                                     "event_login",
                                     "event_post_score",
                                     "event_present_offer",
                                     "event_purchase_refund",
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
                              AnalyticsEventLevelUp,
                              AnalyticsEventLogin,
                              AnalyticsEventPostScore,
                              AnalyticsEventPresentOffer,
                              AnalyticsEventPurchaseRefund,
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
        
        for (index, eventName) in acceptedTealiumEventNames.enumerated() {
            let actual = firebaseCommand.mapEventNames(eventName)
            let expected = firebaseEventNames[index]
            XCTAssertEqual(expected, actual)
        }
        
    }
    
    func testParamsMap() {
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
            let actual = firebaseCommand.paramsMap(parameterName)
            let expected = firebaseParameterNames[index]
            XCTAssertEqual(expected, actual)
        }
        
        
    }

}
