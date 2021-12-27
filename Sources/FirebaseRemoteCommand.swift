//
//  FirebaseRemoteCommand.swift
//  TealiumFirebase
//
//  Created by Christina S on 05/20/20.
//  Copyright © 2017 Tealium. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumRemoteCommands
#endif

public class FirebaseRemoteCommand: RemoteCommand {

    override public var version: String? {
        return FirebaseConstants.version
    }
    var firebaseInstance: FirebaseCommand?

    public init(firebaseInstance: FirebaseCommand = FirebaseInstance(), type: RemoteCommandType = .webview) {
        self.firebaseInstance = firebaseInstance
        weak var weakSelf: FirebaseRemoteCommand?
        super.init(commandId: FirebaseConstants.commandId,
                   description: FirebaseConstants.description,
            type: type,
            completion: { response in
                guard let payload = response.payload else {
                    return
                }
                weakSelf?.processRemoteCommand(with: payload)
            })
        weakSelf = self
    }

    func processRemoteCommand(with payload: [String: Any]) {
        guard let firebaseInstance = firebaseInstance,
            let command = payload[FirebaseConstants.commandName] as? String else {
                return
        }
        let commands = command.split(separator: FirebaseConstants.separator)
        let firebaseCommands = commands.map { command in
            return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        var firebaseLogLevel = FirebaseLoggerLevel.min
        firebaseCommands.forEach {
            let command = FirebaseConstants.Commands(rawValue: $0.lowercased())
            switch command {
            case .config:
                var firebaseSessionTimeout: TimeInterval?
                var firebaseSessionMinimumSeconds: TimeInterval?
                var firebaseAnalyticsEnabled: Bool?
                if let sessionTimeout = payload[FirebaseConstants.Keys.sessionTimeout] as? String {
                    firebaseSessionTimeout = TimeInterval(sessionTimeout)
                }
                if let sessionMinimumSeconds = payload[FirebaseConstants.Keys.minSeconds] as? String {
                    firebaseSessionMinimumSeconds = TimeInterval(sessionMinimumSeconds)
                }
                if let analyticsEnabled = payload[FirebaseConstants.Keys.analyticsEnabled] as? String {
                    firebaseAnalyticsEnabled = Bool(analyticsEnabled)
                }
                if let logLevel = payload[FirebaseConstants.Keys.logLevel] as? String {
                    firebaseLogLevel = self.parseLogLevel(logLevel)
                }
                firebaseInstance.createAnalyticsConfig(firebaseSessionTimeout, firebaseSessionMinimumSeconds, firebaseAnalyticsEnabled, firebaseLogLevel)
            case .logEvent:
                var payload = payload
                guard let name = payload[FirebaseConstants.Keys.eventName] as? String else {
                    return
                }
                let eventName = self.mapEvent(name)
                var normalizedParams = [String: Any]()
                if let eventKeyFromJSON = payload[FirebaseConstants.Keys.eventKey] as? [String: Any] {
                    payload[FirebaseConstants.Keys.eventParams] = eventKeyFromJSON
                }
                guard let params = payload[FirebaseConstants.Keys.eventParams] as? [String: Any] else {
                    firebaseInstance.logEvent(eventName, items(from: payload))
                    return
                }
                normalizedParams += mapParams(params)
                if let itemsArray = params[FirebaseConstants.Keys.paramItems] as? [[String: Any]] {
                    var tempItems = [[String: Any]]()
                    itemsArray.forEach {
                        let item = mapParams($0)
                        tempItems.append(item)
                    }
                    normalizedParams[FirebaseConstants.Keys.items] = tempItems
                    normalizedParams = normalizedParams.filter { $0.key != FirebaseConstants.Keys.paramItems}
                } else if let jsonItems = payload[FirebaseConstants.Keys.items] as? [String: Any] {
                    normalizedParams += items(from: jsonItems)
                }
                firebaseInstance.logEvent(eventName, normalizedParams)
            case .setScreenName:
                guard let screenName = payload[FirebaseConstants.Keys.screenName] as? String else {
                    if firebaseLogLevel == .debug {
                        print("\(FirebaseConstants.errorPrefix)`screen_name` required for setScreenName.")
                    }
                    return
                }
                let screenClass = payload[FirebaseConstants.Keys.screenClass] as? String
                firebaseInstance.setScreenName(screenName, screenClass)
            case .setUserProperty:
                // Multiple user properties
                if let propertyNames = payload[FirebaseConstants.Keys.userPropertyName] as? [String],
                   let propertyValues = payload[FirebaseConstants.Keys.userPropertyValue] as? [String] {
                    zip(propertyNames, propertyValues).forEach {
                        firebaseInstance.setUserProperty($0.0, value: $0.1)
                    }
                }
                // Single user property
                if let propertyName = payload[FirebaseConstants.Keys.userPropertyName] as? String,
                   let propertyValue = payload[FirebaseConstants.Keys.userPropertyValue] as? String {
                    firebaseInstance.setUserProperty(propertyName, value: propertyValue)
                }
            case .setUserId:
                guard let userId = payload[FirebaseConstants.Keys.userId] as? String else {
                    if firebaseLogLevel == .debug {
                        print("\(FirebaseConstants.errorPrefix)`firebase_user_id` required for setUserId.")
                    }
                    return
                }
                firebaseInstance.setUserId(userId)
            default:
                return
            }
        }
    }
    
    func items(from payload: [String: Any]) -> [String: Any] {
        var result = [String: Any]()

        func prepare(items: [String: Any]) -> [String: Any] {
            var result = [String: Any]()
            if let items = items.extractItems(), items.count > 0 {
                result[FirebaseConstants.Keys.items] = items
            } else if let items = items.itemsToArray().extractItems(), items.count > 0 {
                result[FirebaseConstants.Keys.items] = items
            }
            return result
        }
        
        if let jsonItems = payload[FirebaseConstants.Keys.items] as? [String: Any] {
            result = prepare(items: jsonItems)
        } else {
            result = prepare(items: payload)
        }
        result += mapParams(result)
        return result
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
            "event_earn_virtual_currency": AnalyticsEventEarnVirtualCurrency,
            "event_generate_lead": AnalyticsEventGenerateLead,
            "event_join_group": AnalyticsEventJoinGroup,
            "event_level_end": AnalyticsEventLevelEnd,
            "event_level_start": AnalyticsEventLevelStart,
            "event_level_up": AnalyticsEventLevelUp,
            "event_login": AnalyticsEventLogin,
            "event_post_score": AnalyticsEventPostScore,
            "event_present_offer": AnalyticsEventViewPromotion,
            "event_ecommerce_purchase": AnalyticsEventPurchase,
            "event_purchase": AnalyticsEventPurchase,
            "event_purchase_refund": AnalyticsEventRefund,
            "event_refund": AnalyticsEventRefund,
            "event_remove_cart": AnalyticsEventRemoveFromCart,
            "event_search": AnalyticsEventSearch,
            "event_select_content": AnalyticsEventSelectContent,
            "event_select_item": AnalyticsEventSelectItem,
            "event_select_promotion": AnalyticsEventSelectPromotion,
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
    
    func mapParams(_ payload: [String: Any]) -> [String: Any] {
        var result = [String: Any]()
        payload.forEach {
            let paramName = paramFrom($0.key)
            result[paramName] = $0.value
        }
        return result
    }
    
    func paramFrom(_ paramName: String) -> String {
        let eventParameters = [
            "param_achievement_id": AnalyticsParameterAchievementID,
            "param_ad_network_click_id": AnalyticsParameterAdNetworkClickID,
            "param_affiliation": AnalyticsParameterAffiliation,
            "param_cp1": AnalyticsParameterCP1,
            "param_campaign": AnalyticsParameterCampaign,
            "param_character": AnalyticsParameterCharacter,
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
            "param_item_list": AnalyticsParameterItemListName,
            "param_item_list_id": AnalyticsParameterItemListID,
            "param_item_list_name": AnalyticsParameterItemListName,
            "param_item_location_id": AnalyticsParameterLocationID,
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
            "param_signup_method": AnalyticsParameterMethod,
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
        return eventParameters[paramName] ?? paramName
    }

}

fileprivate extension Dictionary where Key == String, Value == Any {
    func extractItems() -> [[String: Any]]? {
        [FirebaseItem](from: self)?.dictionaryArray
    }
    func itemsToArray() -> [String: Any] {
        self.reduce(into: [String: Any]()) { result, dictionary in
            if dictionary.key.contains("item_") ||
                dictionary.key.contains("quantity") ||
                dictionary.key.contains("price") {
                guard let _ = dictionary.value as? [Any] else {
                    result[dictionary.key] = [dictionary.value]
                    return
                }
            }
        }
    }
}
