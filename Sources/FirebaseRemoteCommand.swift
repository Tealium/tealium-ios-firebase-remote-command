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
    let firebaseInstance: FirebaseCommand

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
    
    public func onReady(_ onReady: @escaping () -> Void) {
        TealiumQueues.backgroundSerialQueue.async {
            self.firebaseInstance.onReady(onReady)
        }
    }

    func processRemoteCommand(with payload: [String: Any]) {
        guard let command = payload[FirebaseConstants.commandName] as? String else {
                return
        }
        let commands = command.split(separator: FirebaseConstants.separator)
        let firebaseCommands = commands.map { command in
            return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        var firebaseLogLevel = FirebaseLoggerLevel.min
        firebaseCommands
            .compactMap { FirebaseConstants.Commands(rawValue: $0.lowercased()) }
            .forEach { command in
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
                
                // Configure FirebaseValidator settings
                let invalidCharStrategy = payload[FirebaseConstants.Keys.invalidCharStrategy] as? String ?? FirebaseValidator.strategyReplace
                FirebaseValidator.setInvalidCharStrategy(invalidCharStrategy)
                
                let ga360Mode = (payload[FirebaseConstants.Keys.ga360Mode] as? String).flatMap { Bool($0) } ?? false
                FirebaseValidator.setGA360Mode(ga360Mode)
                
                firebaseInstance.createAnalyticsConfig(firebaseSessionTimeout, firebaseSessionMinimumSeconds, firebaseAnalyticsEnabled, firebaseLogLevel)
            case .logEvent:
                var payload = payload
                guard let name = payload[FirebaseConstants.Keys.eventName] as? String else {
                    return
                }
                let eventName = self.mapEvent(name)
                
                // Validate and sanitize event name
                let eventResult = FirebaseValidator.validateEventName(eventName)
                if !eventResult.isValid {
                    if firebaseLogLevel == .debug {
                        print("\(FirebaseValidator.errorPrefix)\(eventResult.errorMessage)")
                    }
                    return // Don't send invalid events that can't be sanitized
                }
                if eventResult.isSanitized() {
                    if firebaseLogLevel == .debug {
                        print("\(FirebaseValidator.warningPrefix)\(eventResult.errorMessage) ('\(eventResult.originalValue ?? "")' → '\(eventResult.sanitizedValue ?? "")')")
                    }
                }
                
                var normalizedParams = [String: Any]()
                if let eventKeyFromJSON = payload[FirebaseConstants.Keys.eventKey] as? [String: Any] {
                    payload[FirebaseConstants.Keys.eventParams] = eventKeyFromJSON // event params from json remote command
                }
                guard let params = payload[FirebaseConstants.Keys.eventParams] as? [String: Any] else {
                    firebaseInstance.logEvent(eventResult.sanitizedValue ?? eventName, items(from: payload, logLevel: firebaseLogLevel))
                    return
                }
                
                // Validate and sanitize parameters
                let mappedParams = mapParams(params)
                let sanitizedParams = validateAndSanitizeParameters(mappedParams, logLevel: firebaseLogLevel)
                normalizedParams += sanitizedParams
                
                if let itemsArray = params[FirebaseConstants.Keys.paramItems] as? [[String: Any]] {
                    normalizedParams[FirebaseConstants.Keys.items] = itemsArray.map { item in
                        let mappedItem = mapParams(item)
                        return validateAndSanitizeParameters(mappedItem, logLevel: firebaseLogLevel)
                    }
                    normalizedParams.removeValue(forKey: FirebaseConstants.Keys.paramItems)
                } else if let jsonItems = payload[FirebaseConstants.Keys.items] as? [String: Any] {
                    normalizedParams += items(from: jsonItems, logLevel: firebaseLogLevel)
                }
                firebaseInstance.logEvent(eventResult.sanitizedValue ?? eventName, normalizedParams)
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
                    zip(propertyNames, propertyValues).forEach { name, value in
                        // Validate and sanitize user property name
                        let propertyResult = FirebaseValidator.validateUserPropertyName(name)
                        if !propertyResult.isValid {
                            if firebaseLogLevel == .debug {
                                print("\(FirebaseValidator.errorPrefix)\(propertyResult.errorMessage)")
                            }
                            return // Skip invalid property names that can't be sanitized
                        }
                        if propertyResult.isSanitized() {
                            if firebaseLogLevel == .debug {
                                print("\(FirebaseValidator.warningPrefix)\(propertyResult.errorMessage) ('\(propertyResult.originalValue ?? "")' → '\(propertyResult.sanitizedValue ?? "")')")
                            }
                        }
                        
                        // Validate and truncate user property value
                        let valueResult = FirebaseValidator.validateUserPropertyValue(value)
                        if valueResult.isSanitized() {
                            if firebaseLogLevel == .debug {
                                print("\(FirebaseValidator.warningPrefix)\(valueResult.errorMessage) ('\(valueResult.originalValue ?? "")' → '\(valueResult.sanitizedValue ?? "")')")
                            }
                        }
                        
                        firebaseInstance.setUserProperty(propertyResult.sanitizedValue ?? name, value: valueResult.sanitizedValue ?? value)
                    }
                }
                // Single user property
                if let propertyName = payload[FirebaseConstants.Keys.userPropertyName] as? String,
                   let propertyValue = payload[FirebaseConstants.Keys.userPropertyValue] as? String {
                    // Validate and sanitize user property name
                    let propertyResult = FirebaseValidator.validateUserPropertyName(propertyName)
                    if !propertyResult.isValid {
                        if firebaseLogLevel == .debug {
                            print("\(FirebaseValidator.errorPrefix)\(propertyResult.errorMessage)")
                        }
                        return // Skip invalid property names that can't be sanitized
                    }
                    if propertyResult.isSanitized() {
                        if firebaseLogLevel == .debug {
                            print("\(FirebaseValidator.warningPrefix)\(propertyResult.errorMessage) ('\(propertyResult.originalValue ?? "")' → '\(propertyResult.sanitizedValue ?? "")')")
                        }
                    }
                    
                    // Validate and truncate user property value
                    let valueResult = FirebaseValidator.validateUserPropertyValue(propertyValue)
                    if valueResult.isSanitized() {
                        if firebaseLogLevel == .debug {
                            print("\(FirebaseValidator.warningPrefix)\(valueResult.errorMessage) ('\(valueResult.originalValue ?? "")' → '\(valueResult.sanitizedValue ?? "")')")
                        }
                    }
                    
                    firebaseInstance.setUserProperty(propertyResult.sanitizedValue ?? propertyName, value: valueResult.sanitizedValue ?? propertyValue)
                }
            case .setUserId:
                guard let userId = payload[FirebaseConstants.Keys.userId] as? String else {
                    if firebaseLogLevel == .debug {
                        print("\(FirebaseConstants.errorPrefix)`firebase_user_id` required for setUserId.")
                    }
                    return
                }
                firebaseInstance.setUserId(userId)
            case .initiateConversionMeasurement:
                if let hashedEmailAddress = payload[FirebaseConstants.Keys.hashedEmailAddress] as? String {
                    firebaseInstance.initiateOnDeviceConversionMeasurement(hashedEmailAdress: Data(hashedEmailAddress.utf8))
                } else if let hashedPhoneNumber = payload[FirebaseConstants.Keys.hashedPhoneNumber] as? String {
                    firebaseInstance.initiateOnDeviceConversionMeasurement(hashedPhoneNumber: Data(hashedPhoneNumber.utf8))
                } else if let emailAddress = payload[FirebaseConstants.Keys.emailAddress] as? String {
                    firebaseInstance.initiateOnDeviceConversionMeasurement(emailAddress: emailAddress)
                } else if let phoneNumber = payload[FirebaseConstants.Keys.phoneNumber] as? String {
                    firebaseInstance.initiateOnDeviceConversionMeasurement(phoneNumber: phoneNumber)
                } else if firebaseLogLevel == .debug {
                    print("\(FirebaseConstants.errorPrefix) one of the following: `\(FirebaseConstants.Keys.emailAddress)`, `\(FirebaseConstants.Keys.phoneNumber)`,`\(FirebaseConstants.Keys.hashedEmailAddress)`, `\(FirebaseConstants.Keys.phoneNumber) is required for \(command).")
                }
            case .setDefaultParameters:
                let params = payload[FirebaseConstants.Keys.defaultParams] as? [String: Any]
                    ?? payload[FirebaseConstants.Keys.tagDefaultParams] as? [String: Any]
                if let params = params, !params.isEmpty {
                    // Validate and sanitize default parameter names
                    let sanitizedParams = validateAndSanitizeParameters(params, logLevel: firebaseLogLevel)
                    firebaseInstance.setDefaultEventParameters(parameters: sanitizedParams)
                } else {
                    firebaseInstance.setDefaultEventParameters(parameters: params)
                }
            case .setConsent:
                guard let settings = payload[FirebaseConstants.Keys.consentSettings] as? [String: String] else {
                    return
                }
                firebaseInstance.setConsent(settings)
            case .resetAnalyticsData:
                firebaseInstance.resetAnalyticsData()
            }
        }
    }
    
    func items(from payload: [String: Any], logLevel: FirebaseLoggerLevel) -> [String: Any] {
        let payloadParameters = payload[FirebaseConstants.Keys.items] as? [String: Any] ?? payload
        return [
            FirebaseConstants.Keys.items: payloadParameters.itemArraysToArrayOfItems().map { item in
                let mappedItem = mapParams(item)
                return validateAndSanitizeParameters(mappedItem, logLevel: logLevel)
            }
        ]
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
        return FirebaseRemoteCommand.eventsMap[eventName] ?? eventName
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
        return FirebaseRemoteCommand.eventParameters[paramName] ?? paramName
    }
    
    /**
     * Validates and sanitizes parameter names in a dictionary
     * 
     * @param params The dictionary containing parameters to validate
     * @param logLevel The current log level for conditional logging
     * @return Dictionary with sanitized parameter names (original dictionary if no changes needed)
     */
    func validateAndSanitizeParameters(_ params: [String: Any], logLevel: FirebaseLoggerLevel) -> [String: Any] {
        var sanitizedParams = [String: Any]()
        
        for (originalKey, paramValue) in params {
            // Validate and sanitize parameter name
            let paramResult = FirebaseValidator.validateParameterName(originalKey)
            if !paramResult.isValid {
                if logLevel == .debug {
                    print("\(FirebaseValidator.errorPrefix)\(paramResult.errorMessage)")
                }
                continue // Skip invalid parameter names
            }
            
            if paramResult.isSanitized() {
                if logLevel == .debug {
                    print("\(FirebaseValidator.warningPrefix)\(paramResult.errorMessage) ('\(paramResult.originalValue ?? "")' → '\(paramResult.sanitizedValue ?? "")')")
                }
            }
            
            // Validate parameter value if it's a string
            if let stringValue = paramValue as? String {
                let valueResult = FirebaseValidator.validateParameterValue(stringValue)
                if valueResult.isSanitized() {
                    if logLevel == .debug {
                        print("\(FirebaseValidator.warningPrefix)\(valueResult.errorMessage) ('\(valueResult.originalValue ?? "")' → '\(valueResult.sanitizedValue ?? "")')")
                    }
                }
                sanitizedParams[paramResult.sanitizedValue ?? originalKey] = valueResult.sanitizedValue ?? stringValue
            } else {
                // Non-string values (numbers, etc.) - use as-is
                sanitizedParams[paramResult.sanitizedValue ?? originalKey] = paramValue
            }
        }
        
        return sanitizedParams
    }

}

extension Dictionary where Key == String, Value == Any {
    
    func normalizeParamsArrays() -> [String: [Any]] {
        self.filter { $0.key.starts(with: "param_item") || $0.key == "param_quantity" || $0.key == "param_price" }
            .reduce(into: [String: [Any]]()) { result, dictionary in
                result[dictionary.key] = dictionary.value as? [Any] ?? [dictionary.value]
            }
    }
    
    func itemArraysToArrayOfItems() -> [[String: Any]] {
        let itemParamsArrays = normalizeParamsArrays()
        // We assume that all arrays have the same length
        let count = itemParamsArrays.first?.value.count ?? 0
        var result = Array<[String: Any]>(repeating: [:], count: count)
        for i in 0 ..< count {
            for key in itemParamsArrays.keys {
                if let values = itemParamsArrays[key], values.count > i {
                    result[i][key] = values[i]
                }
            }
        }
        return result
    }
}

// Firebase Analytics Event and Parameter Names
// See: https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Constants#/c:FIRParameterNames.h
extension FirebaseRemoteCommand {
    static let eventParameters = [
        "param_achievement_id": AnalyticsParameterAchievementID,
        "param_ad_format": AnalyticsParameterAdFormat,
        "param_ad_network_click_id": AnalyticsParameterAdNetworkClickID,
        "param_ad_platform": AnalyticsParameterAdPlatform,
        "param_ad_source": AnalyticsParameterAdSource,
        "param_ad_unit_name": AnalyticsParameterAdUnitName,
        "param_affiliation": AnalyticsParameterAffiliation,
        "param_cp1": AnalyticsParameterCP1,
        "param_campaign": AnalyticsParameterCampaign,
        "param_campaign_id": AnalyticsParameterCampaignID, // Version 8.12.1
        "param_character": AnalyticsParameterCharacter,
        "param_content": AnalyticsParameterContent,
        "param_content_type": AnalyticsParameterContentType,
        "param_coupon": AnalyticsParameterCoupon,
        "param_creative_format": AnalyticsParameterCreativeFormat, // Version 8.12.1
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
        "param_item_category2": AnalyticsParameterItemCategory2,
        "param_item_category3": AnalyticsParameterItemCategory3,
        "param_item_category4": AnalyticsParameterItemCategory4,
        "param_item_category5": AnalyticsParameterItemCategory5,
        "param_item_id": AnalyticsParameterItemID,
        "param_item_list_id": AnalyticsParameterItemListID,
        "param_item_list_name": AnalyticsParameterItemListName,
        "param_item_name": AnalyticsParameterItemName,
        "param_item_variant": AnalyticsParameterItemVariant,
        "param_items": AnalyticsParameterItems,
        "param_level": AnalyticsParameterLevel,
        "param_level_name": AnalyticsParameterLevelName,
        "param_location": AnalyticsParameterLocation,
        "param_location_id": AnalyticsParameterLocationID,
        "param_marketing_tactic": AnalyticsParameterMarketingTactic, // version 8.12.1
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
        "param_screen_name": AnalyticsParameterScreenName,
        "param_screen_class": AnalyticsParameterScreenClass,
        "param_source": AnalyticsParameterSource,
        "param_source_platform": AnalyticsParameterSourcePlatform, // Version 8.12.1
        "param_start_date": AnalyticsParameterStartDate,
        "param_success": AnalyticsParameterSuccess,
        "param_tax": AnalyticsParameterTax,
        "param_term": AnalyticsParameterTerm,
        "param_transaction_id": AnalyticsParameterTransactionID,
        "param_travel_class": AnalyticsParameterTravelClass,
        "param_value": AnalyticsParameterValue,
        "param_virtual_currency_name": AnalyticsParameterVirtualCurrencyName,
        "param_user_signup_method": AnalyticsUserPropertySignUpMethod,
        "param_user_allow_ad_personalization_signals": AnalyticsUserPropertyAllowAdPersonalizationSignals
    ]
    
    static let eventsMap = [
        "event_ad_impression": AnalyticsEventAdImpression,
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
        "event_purchase": AnalyticsEventPurchase,
        "event_refund": AnalyticsEventRefund,
        "event_remove_cart": AnalyticsEventRemoveFromCart,
        "event_screen_view": AnalyticsEventScreenView,
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
        "event_view_cart": AnalyticsEventViewCart,
        "event_view_item": AnalyticsEventViewItem,
        "event_view_item_list": AnalyticsEventViewItemList,
        "event_view_promotion": AnalyticsEventViewPromotion,
        "event_view_search_results": AnalyticsEventViewSearchResults,
    ]
}
