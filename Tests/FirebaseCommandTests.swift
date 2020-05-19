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
        acceptedTealiumEventNames = ["event_add_payment_info", "event_add_shipping_info",
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
                                  AnalyticsParameterExtendSession,
                                  AnalyticsParameterFlightNumber,
                                  AnalyticsParameterGroupID,
                                  AnalyticsParameterIndex,
                                  AnalyticsParameterItemBrand,
                                  AnalyticsParameterItemCategory,
                                  AnalyticsParameterItemID,
                                  AnalyticsParameterItemList,
                                  AnalyticsParameterItemListID,
                                  AnalyticsParameterItemListName,
                                  AnalyticsParameterItemLocationID,
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
                                  AnalyticsParameterSignUpMethod,
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
        
        for (index, parameterName) in acceptedTealiumVariableNames.enumerated() {
            let actual = firebaseCommand.paramsMap(parameterName)
            let expected = firebaseParameterNames[index]
            XCTAssertEqual(expected, actual)
        }
        
        
    }

}
