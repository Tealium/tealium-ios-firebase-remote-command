//
//  FirebaseCommand.swift

//
//  Created by Craig Rouse on 18/12/2017.
//  Copyright © 2017 Tealium. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics
#if COCOAPODS
import TealiumSwift
#else
import TealiumCore
import TealiumTagManagement
import TealiumRemoteCommands
#endif

public class FirebaseCommand {

    enum FirebaseKey {
        static let sessionTimeout = "firebase_session_timeout_seconds"
        static let minSeconds = "firebase_session_minimum_seconds"
        static let analyticsEnabled = "firebase_analytics_enabled"
        static let logLevel = "firebase_log_level"
        static let eventName = "firebase_event_name"
        static let eventParams = "firebase_event_params"
        static let screenName = "firebase_screen_name"
        static let screenClass = "firebase_screen_class"
        static let userPropertyName = "firebase_property_name"
        static let userPropertyValue = "firebase_property_value"
        static let userId = "firebase_user_id"
        static let commandName = "command_name"
    }

    enum FirebaseCommand {
        static let config = "config"
        static let logEvent = "logevent"
        static let setScreenName = "setscreenname"
        static let setUserProperty = "setuserproperty"
        static let setUserId = "setuserid"
    }

    var firebaseCommandRunner: FirebaseCommandRunnable

    public init(firebaseCommandRunner: FirebaseCommandRunnable = FirebaseCommandRunner()) {
        self.firebaseCommandRunner = firebaseCommandRunner
    }

    public func remoteCommand() -> TealiumRemoteCommand {
        return TealiumRemoteCommand(commandId: "firebaseAnalytics", description: "Firebase Remote Command") { response in

            let payload = response.payload()
            guard let command = payload["command_name"] as? String else {
                return
            }
            let commands = command.split(separator: ",")
            let firebaseCommands = commands.map { command in
                return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
             self.parseCommands(firebaseCommands, payload: payload)
        }
    }
    
    func parseCommands(_ commands: [String], payload: [String: Any]) {
        commands.forEach { command in
            let lowercasedCommand = command.lowercased()
            switch lowercasedCommand {
            case FirebaseCommand.config:
                var firebaseSessionTimeout: TimeInterval?
                var firebaseSessionMinimumSeconds: TimeInterval?
                var firebaseAnalyticsEnabled: Bool?
                var firebaseLogLevel = FirebaseLoggerLevel.min
                if let sessionTimeout = payload[FirebaseKey.sessionTimeout] as? String {
                    firebaseSessionTimeout = TimeInterval(sessionTimeout)
                }
                if let sessionMinimumSeconds = payload[FirebaseKey.minSeconds] as? String {
                    firebaseSessionMinimumSeconds = TimeInterval(sessionMinimumSeconds)
                }
                if let analyticsEnabled = payload[FirebaseKey.analyticsEnabled] as? String {
                    firebaseAnalyticsEnabled = Bool(analyticsEnabled)
                }
                if let logLevel = payload[FirebaseKey.logLevel] as? String {
                    firebaseLogLevel = self.parseLogLevel(logLevel)
                }
                self.firebaseCommandRunner.createAnalyticsConfig(firebaseSessionTimeout, firebaseSessionMinimumSeconds, firebaseAnalyticsEnabled, firebaseLogLevel)
            case FirebaseCommand.logEvent:
                guard let name = payload[FirebaseKey.eventName] as? String else {
                    return
                }
                let eventName = self.mapEventNames(name)
                guard let params = payload[FirebaseKey.eventParams] as? Dictionary<String, Any> else {
                    return
                }
                var normalizedParams = [String: Any]()
                for param in params {
                    let newKeyName = self.paramsMap(param.key)
                    if let normalizedValue = param.value as? NSArray {
                        normalizedParams[newKeyName] = normalizedValue.componentsJoined(by: ",")
                    } else {
                        normalizedParams[newKeyName] = param.value
                    }
                }
                self.firebaseCommandRunner.logEvent(eventName, normalizedParams)
            case FirebaseCommand.setScreenName:
                guard let screenName = payload[FirebaseKey.screenName] as? String else {
                    return
                }
                let screenClass = payload[FirebaseKey.screenClass] as? String
                self.firebaseCommandRunner.setScreenName(screenName, screenClass)
            case FirebaseCommand.setUserProperty:
                guard let propertyName = payload[FirebaseKey.userPropertyName] as? String else {
                    return
                }
                guard let propertyValue = payload[FirebaseKey.userPropertyValue] as? String else {
                    return
                }
                self.firebaseCommandRunner.setUserProperty(propertyName, value: propertyValue)
            case FirebaseCommand.setUserId:
                guard let userId = payload[FirebaseKey.userId] as? String else {
                    return
                }
                self.firebaseCommandRunner.setUserId(userId)
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

    func mapEventNames(_ eventName: String) -> String {
        let eventsMap = [
            "add_payment_info": AnalyticsEventAddPaymentInfo,
            "add_to_cart": AnalyticsEventAddToCart,
            "add_to_wishlist": AnalyticsEventAddToWishlist,
            "app_open": AnalyticsEventAppOpen,
            "event_begin_checkout": AnalyticsEventBeginCheckout,
            "event_campaign_details": AnalyticsEventCampaignDetails,
            "event_checkout_progress": AnalyticsEventCheckoutProgress,
            "event_earn_virtual_currency": AnalyticsEventEarnVirtualCurrency,
            "event_ecommerce_purchase": AnalyticsEventEcommercePurchase,
            "event_generate_lead": AnalyticsEventGenerateLead,
            "event_join_group": AnalyticsEventJoinGroup,
            "event_level_up": AnalyticsEventLevelUp,
            "event_login": AnalyticsEventLogin,
            "event_post_score": AnalyticsEventPostScore,
            "event_present_offer": AnalyticsEventPresentOffer,
            "event_purchase_refund": AnalyticsEventPurchaseRefund,
            "event_remove_cart": AnalyticsEventRemoveFromCart,
            "event_search": AnalyticsEventSearch,
            "event_select_content": AnalyticsEventSelectContent,
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

    func paramsMap(_ paramName: String) -> String {
        let paramsMap = [
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
            "param_end_date": AnalyticsParameterEndDate,
            "param_flight_number": AnalyticsParameterFlightNumber,
            "param_group_id": AnalyticsParameterGroupID,
            "param_index": AnalyticsParameterIndex,
            "param_item_brand": AnalyticsParameterItemBrand,
            "param_item_category": AnalyticsParameterItemCategory,
            "param_item_id": AnalyticsParameterItemID,
            "param_item_list": AnalyticsParameterItemList,
            "param_item_location_id": AnalyticsParameterItemLocationID,
            "param_item_name": AnalyticsParameterItemName,
            "param_item_variant": AnalyticsParameterItemVariant,
            "param_level": AnalyticsParameterLevel,
            "param_location": AnalyticsParameterLocation,
            "param_medium": AnalyticsParameterMedium,
            "param_number_nights": AnalyticsParameterNumberOfNights,
            "param_number_pax": AnalyticsParameterNumberOfPassengers,
            "param_number_rooms": AnalyticsParameterNumberOfRooms,
            "param_origin": AnalyticsParameterOrigin,
            "param_price": AnalyticsParameterPrice,
            "param_quantity": AnalyticsParameterQuantity,
            "param_score": AnalyticsParameterScore,
            "param_search_term": AnalyticsParameterSearchTerm,
            "param_shipping": AnalyticsParameterShipping,
            "param_signup_method": AnalyticsParameterSignUpMethod,
            "param_source": AnalyticsParameterSource,
            "param_start_date": AnalyticsParameterStartDate,
            "param_tax": AnalyticsParameterTax,
            "param_term": AnalyticsParameterTerm,
            "param_transaction_id": AnalyticsParameterTransactionID,
            "param_travel_class": AnalyticsParameterTravelClass,
            "param_value": AnalyticsParameterValue,
            "param_virtual_currency_name": AnalyticsParameterVirtualCurrencyName,
            "param_user_signup_method": AnalyticsUserPropertySignUpMethod
        ]
        return paramsMap[paramName] ?? paramName
    }

}

