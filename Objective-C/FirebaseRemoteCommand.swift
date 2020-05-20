//
//  FirebaseRemoteCommand.swift
//  TealiumRemoteCommandObjcApp
//
//  Created by Christina S on 5/20/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAnalytics
import TealiumIOS

@objc
public class FirebaseRemoteCommand: NSObject {

    var firebaseTracker: FirebaseTrackable

    @objc
    public init(firebaseTracker: FirebaseTrackable = FirebaseTracker()) {
        self.firebaseTracker = firebaseTracker
    }

    @objc
    public func remoteCommand() -> TEALRemoteCommandResponseBlock {
        return { response in
            guard let payload = response?.requestPayload as? [String: Any],
                let command = payload[.commandName] as? String else {
                return
            }
            let commands = command.split(separator: FirebaseConstants.separator)
            let firebaseCommands = commands.map { command in
                return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            self.parseCommands(firebaseCommands, payload: payload)
        }
    }

    func parseCommands(_ commands: [String], payload: [String: Any]) {
        var firebaseLogLevel = FirebaseLoggerLevel.min
        commands.forEach {
            let command = FirebaseConstants.Commands(rawValue: $0.lowercased())
            switch command {
            case .config:
                var configuration = [String: Any]()
                if let sessionTimeout = payload[.sessionTimeout] as? String {
                    configuration[.sessionTimeout] = TimeInterval(sessionTimeout)
                }
                if let sessionMinimumSeconds = payload[.minSeconds] as? String {
                    configuration[.minSeconds] = TimeInterval(sessionMinimumSeconds)
                }
                if let analyticsEnabled = payload[.analyticsEnabled] as? String {
                    configuration[.analyticsEnabled] = Bool(analyticsEnabled)
                }
                guard let logLevel = payload[.logLevel] as? String else {
                    configuration[.logLevel] = firebaseLogLevel
                    return self.firebaseTracker.createAnalyticsConfig(configuration)
                }
                firebaseLogLevel = self.parseLogLevel(logLevel)
                configuration[.logLevel] = firebaseLogLevel
                self.firebaseTracker.createAnalyticsConfig(configuration)
            case .logEvent:
                guard let name = payload[.eventName] as? String else {
                    return
                }
                let eventName = self.mapEvent(name)
                var normalizedParams = [String: Any]()
                guard let params = payload[.eventParams] as? [String: Any] else {
                    return self.firebaseTracker.logEvent(eventName, nil)
                }
                if let items = params[.paramItems] as? [[String: Any]] {
                    var tempItems = [[String: Any]]()
                    var item = [String: Any]()
                    items.forEach {
                        item = eventParameters.map($0)
                        tempItems.append(item)
                    }
                    normalizedParams[.items] = tempItems
                }
                normalizedParams.merge(eventParameters.map(params)) { _, new in new }
                self.firebaseTracker.logEvent(eventName, normalizedParams)
            case .setScreenName:
                guard let screenName = payload[.screenName] as? String else {
                    if firebaseLogLevel == .debug {
                        print("\(FirebaseConstants.errorPrefix)`screen_name` required for setScreenName.")
                    }
                    return
                }
                let screenClass = payload[.screenClass] as? String
                self.firebaseTracker.setScreenName(screenName, screenClass)
            case .setUserProperty:
                guard let propertyName = payload[.userPropertyName] as? String else {
                    if firebaseLogLevel == .debug {
                        print("\(FirebaseConstants.errorPrefix)`firebase_property_name` required for setUserProperty.")
                    }
                    return
                }
                guard let propertyValue = payload[.userPropertyValue] as? String else {
                    if firebaseLogLevel == .debug {
                        print("\(FirebaseConstants.errorPrefix)`firebase_property_value` required for setUserProperty.")
                    }
                    return
                }
                self.firebaseTracker.setUserProperty(propertyName, value: propertyValue)
            case .setUserId:
                guard let userId = payload[.userId] as? String else {
                    if firebaseLogLevel == .debug {
                        print("\(FirebaseConstants.errorPrefix)`firebase_user_id` required for setUserId.")
                    }
                    return
                }
                self.firebaseTracker.setUserId(userId)
            default:
                return
            }
        }
    }

    func parseLogLevel(_ logLevel: String) -> FirebaseLoggerLevel {
        switch logLevel {
        case "min":
            return FirebaseLoggerLevel.min
        case "max":
            return FirebaseLoggerLevel.max
        case "error":
            return FirebaseLoggerLevel.error
        case "debug":
            return FirebaseLoggerLevel.debug
        case "notice":
            return FirebaseLoggerLevel.notice
        case "warning":
            return FirebaseLoggerLevel.warning
        case "info":
            return FirebaseLoggerLevel.info
        default:
            return FirebaseLoggerLevel.min
        }
    }

    func mapEvent(_ eventName: String) -> String {
        let eventsMap = [
            "event_add_payment_info": AnalyticsEventAddPaymentInfo,
            "event_add_shipping_info": AnalyticsEventAddShippingInfo,
            "event_add_to_cart": AnalyticsEventAddToCart,
            "event_add_to_wishlist": AnalyticsEventAddToWishlist,
            "event_app_open": AnalyticsEventAppOpen,
            "event_begin_checkout": AnalyticsEventBeginCheckout,
            "event_campaign_details": AnalyticsEventCampaignDetails,
            "event_checkout_progress": AnalyticsEventCheckoutProgress,
            "event_earn_virtual_currency": AnalyticsEventEarnVirtualCurrency,
            "event_ecommerce_purchase": AnalyticsEventEcommercePurchase,
            "event_generate_lead": AnalyticsEventGenerateLead,
            "event_join_group": AnalyticsEventJoinGroup,
            "event_level_end": AnalyticsEventLevelEnd,
            "event_level_start": AnalyticsEventLevelStart,
            "event_level_up": AnalyticsEventLevelUp,
            "event_login": AnalyticsEventLogin,
            "event_post_score": AnalyticsEventPostScore,
            "event_present_offer": AnalyticsEventPresentOffer,
            "event_purchase": AnalyticsEventPurchase,
            "event_purchase_refund": AnalyticsEventPurchaseRefund,
            "event_refund": AnalyticsEventRefund,
            "event_remove_cart": AnalyticsEventRemoveFromCart,
            "event_search": AnalyticsEventSearch,
            "event_select_content": AnalyticsEventSelectContent,
            "event_select_item": AnalyticsEventSelectItem,
            "event_select_promotion": AnalyticsEventSelectPromotion,
            "event_set_checkout_option": AnalyticsEventSetCheckoutOption,
            "event_share": AnalyticsEventShare,
            "event_signup": AnalyticsEventSignUp,
            "event_spend_virtual_currency": AnalyticsEventSpendVirtualCurrency,
            "event_tutorial_begin": AnalyticsEventTutorialBegin,
            "event_tutorial_complete": AnalyticsEventTutorialComplete,
            "event_unlock_achievement": AnalyticsEventUnlockAchievement,
            "event_view_item": AnalyticsEventViewItem,
            "event_view_item_list": AnalyticsEventViewItemList,
            "event_view_search_results": AnalyticsEventViewSearchResults
        ]
        return eventsMap[eventName] ?? eventName
    }

    let eventParameters = [
        "param_achievement_id": AnalyticsParameterAchievementID,
        "param_ad_network_click_id": AnalyticsParameterAdNetworkClickID,
        "param_affiliation": AnalyticsParameterAffiliation,
        "param_cp1": AnalyticsParameterCP1,
        "param_campaign": AnalyticsParameterCampaign,
        "param_character": AnalyticsParameterCharacter,
        "param_checkout_option": AnalyticsParameterCheckoutOption,
        "param_checkout_step": AnalyticsParameterCheckoutStep,
        "param_content": AnalyticsParameterContent,
        "param_content_type": AnalyticsParameterContentType,
        "param_coupon": AnalyticsParameterCoupon,
        "param_creative_name": AnalyticsParameterCreativeName,
        "param_creative_slot": AnalyticsParameterCreativeSlot,
        "param_currency": AnalyticsParameterCurrency,
        "param_destination": AnalyticsParameterDestination,
        "param_discount": AnalyticsParameterDiscount,
        "param_end_date": AnalyticsParameterEndDate,
        "param_extend_session": AnalyticsParameterExtendSession,
        "param_flight_number": AnalyticsParameterFlightNumber,
        "param_group_id": AnalyticsParameterGroupID,
        "param_index": AnalyticsParameterIndex,
        "param_item_brand": AnalyticsParameterItemBrand,
        "param_item_category": AnalyticsParameterItemCategory,
        "param_item_id": AnalyticsParameterItemID,
        "param_item_list": AnalyticsParameterItemList,
        "param_item_list_id": AnalyticsParameterItemListID,
        "param_item_list_name": AnalyticsParameterItemListName,
        "param_item_location_id": AnalyticsParameterItemLocationID,
        "param_item_name": AnalyticsParameterItemName,
        "param_item_variant": AnalyticsParameterItemVariant,
        "param_level": AnalyticsParameterLevel,
        "param_level_name": AnalyticsParameterLevelName,
        "param_location": AnalyticsParameterLocation,
        "param_location_id": AnalyticsParameterLocationID,
        "param_medium": AnalyticsParameterMedium,
        "param_method": AnalyticsParameterMethod,
        "param_number_nights": AnalyticsParameterNumberOfNights,
        "param_number_pax": AnalyticsParameterNumberOfPassengers,
        "param_number_rooms": AnalyticsParameterNumberOfRooms,
        "param_origin": AnalyticsParameterOrigin,
        "param_payment_type": AnalyticsParameterPaymentType,
        "param_price": AnalyticsParameterPrice,
        "param_promotion_id": AnalyticsParameterPromotionID,
        "param_promotion_name": AnalyticsParameterPromotionName,
        "param_quantity": AnalyticsParameterQuantity,
        "param_score": AnalyticsParameterScore,
        "param_search_term": AnalyticsParameterSearchTerm,
        "param_shipping": AnalyticsParameterShipping,
        "param_shipping_tier": AnalyticsParameterShippingTier,
        "param_signup_method": AnalyticsParameterSignUpMethod,
        "param_source": AnalyticsParameterSource,
        "param_start_date": AnalyticsParameterStartDate,
        "param_success": AnalyticsParameterSuccess,
        "param_tax": AnalyticsParameterTax,
        "param_term": AnalyticsParameterTerm,
        "param_transaction_id": AnalyticsParameterTransactionID,
        "param_travel_class": AnalyticsParameterTravelClass,
        "param_value": AnalyticsParameterValue,
        "param_virtual_currency_name": AnalyticsParameterVirtualCurrencyName,
        "param_user_signup_method": AnalyticsUserPropertySignUpMethod
    ]

}

fileprivate extension Dictionary where Key == String, Value == String {
    func map(_ payload: [String: Any]) -> [String: Any] {
        return self.reduce(into: [String: Any]()) { result, dictionary in
            if payload[dictionary.key] != nil {
                result[dictionary.value] = payload[dictionary.key]
            }
        }
    }
}
