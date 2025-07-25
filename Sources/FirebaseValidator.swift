//
//  FirebaseValidator.swift
//  TealiumFirebase
//
//  Created by Assistant on 12/16/24.
//  Copyright © 2024 Tealium. All rights reserved.
//

import Foundation

/**
 * Validates Firebase event names, parameter names, and parameter values
 * according to Firebase Analytics requirements.
 * 
 * Handles sanitization of invalid data to ensure Firebase compatibility.
 */
public class FirebaseValidator {
    
    // Firebase naming validation (same rules for event names and parameter names)
    private static let namePattern = "^(?!firebase_|google_|ga_)[a-zA-Z][a-zA-Z0-9_]{0,39}$"
    private static let maxNameLength = 40
    
    // Firebase User Property validation (different rules)
    private static let userPropertyNamePattern = "^(?!firebase_|google_|ga_)[a-zA-Z][a-zA-Z0-9_]{0,23}$"
    private static let maxUserPropertyNameLength = 24
    
    // Firebase value length limits
    private static let maxParameterValueLengthStandard = 100
    private static let maxParameterValueLengthGA360 = 500
    private static let maxUserPropertyValueLength = 36
    
    // Current parameter value length limit (default: standard GA)
    private static var maxParameterValueLength = maxParameterValueLengthStandard
    
    // Logging constants
    public static let validationTag = "Tealium-Firebase-Validation"
    public static let warningPrefix = "VALIDATION_WARNING: "
    public static let errorPrefix = "VALIDATION_ERROR: "
    
    // Invalid character handling strategies
    public static let strategyReplace = "replace"
    public static let strategyRemove = "remove"
    
    // Current strategy (default: replace invalid chars with underscore)
    private static var invalidCharStrategy = strategyReplace
    
    /**
     * Sets the strategy for handling invalid characters in names
     * 
     * @param strategy Either strategyReplace or strategyRemove
     */
    public static func setInvalidCharStrategy(_ strategy: String) {
        if strategy == strategyReplace || strategy == strategyRemove {
            invalidCharStrategy = strategy
        }
    }
    
    /**
     * Sets whether to use GA 360 parameter value length limits (500 chars vs 100)
     * 
     * @param useGA360 true for 500 char limit, false for 100 char limit
     */
    public static func setGA360Mode(_ useGA360: Bool) {
        maxParameterValueLength = useGA360 ? maxParameterValueLengthGA360 : maxParameterValueLengthStandard
    }
    
    /**
     * Exception thrown when event name cannot be sanitized (e.g., only reserved prefix)
     */
    public class FirebaseValidationException: Error {
        public let message: String
        
        public init(_ message: String) {
            self.message = message
        }
    }
    
    /**
     * Result of validation operation containing original and sanitized values
     */
    public class ValidationResult {
        public let isValid: Bool
        public let originalValue: String?
        public let sanitizedValue: String?
        public let errorMessage: String
        
        private init(isValid: Bool, originalValue: String?, sanitizedValue: String?, errorMessage: String) {
            self.isValid = isValid
            self.originalValue = originalValue
            self.sanitizedValue = sanitizedValue
            self.errorMessage = errorMessage
        }
        
        /**
         * Creates a successful validation result (no changes needed)
         */
        public static func valid(_ value: String?) -> ValidationResult {
            return ValidationResult(isValid: true, originalValue: value, sanitizedValue: value, errorMessage: "Valid")
        }
        
        /**
         * Creates a validation result with sanitized value
         */
        public static func sanitized(_ originalValue: String?, _ sanitizedValue: String?, _ errorMessage: String) -> ValidationResult {
            return ValidationResult(isValid: true, originalValue: originalValue, sanitizedValue: sanitizedValue, errorMessage: errorMessage)
        }
        
        /**
         * Creates an invalid validation result
         */
        public static func invalid(_ originalValue: String?, _ sanitizedValue: String?, _ errorMessage: String) -> ValidationResult {
            return ValidationResult(isValid: false, originalValue: originalValue, sanitizedValue: sanitizedValue, errorMessage: errorMessage)
        }
        
        /**
         * Checks if the validation result is a sanitized value
         * @return true if the original value is not equal to the sanitized value, false otherwise
         */
        public func isSanitized() -> Bool {
            if !isValid { return false }
            guard let original = originalValue else { return false }
            return original != sanitizedValue
        }
    }
    
    /**
     * Validates and sanitizes Firebase event name
     * Always returns a valid Firebase-compatible event name
     * 
     * @param eventName The event name to validate
     * @return ValidationResult with original and sanitized values
     */
    public static func validateEventName(_ eventName: String?) -> ValidationResult {
        return validateName(eventName, invalidFallback: "invalid_event", sanitizationPrefix: "event_", nameType: "Event name")
    }
    
    /**
     * Validates and sanitizes Firebase parameter name
     * Always returns a valid Firebase-compatible parameter name
     * 
     * @param paramName The parameter name to validate
     * @return ValidationResult with original and sanitized values
     */
    public static func validateParameterName(_ paramName: String?) -> ValidationResult {
        return validateName(paramName, invalidFallback: "invalid_param", sanitizationPrefix: "param_", nameType: "Parameter name")
    }
    
    /**
     * Validates and sanitizes Firebase user property name
     * User properties have different length limits (24 chars vs 40)
     * 
     * @param propertyName The user property name to validate
     * @return ValidationResult with original and sanitized values
     */
    public static func validateUserPropertyName(_ propertyName: String?) -> ValidationResult {
        return validateUserPropertyNameInternal(propertyName, invalidFallback: "invalid_property", sanitizationPrefix: "prop_", nameType: "User property name")
    }
    
    /**
     * Validates and truncates Firebase parameter value if needed
     * Uses current maxParameterValueLength (100 or 500 chars based on GA 360 setting)
     * 
     * @param paramValue The parameter value to validate
     * @return ValidationResult with original and truncated values
     */
    public static func validateParameterValue(_ paramValue: String?) -> ValidationResult {
        guard let paramValue = paramValue else {
            return ValidationResult.valid(nil)
        }
        
        if paramValue.count <= maxParameterValueLength {
            return ValidationResult.valid(paramValue)
        }
        
        let truncated = String(paramValue.prefix(maxParameterValueLength))
        return ValidationResult.sanitized(paramValue, truncated, "Parameter value truncated to \(maxParameterValueLength) characters")
    }
    
    /**
     * Validates and truncates Firebase user property value if needed (36 char limit)
     * 
     * @param propertyValue The user property value to validate
     * @return ValidationResult with original and truncated values
     */
    public static func validateUserPropertyValue(_ propertyValue: String?) -> ValidationResult {
        guard let propertyValue = propertyValue else {
            return ValidationResult.valid(nil)
        }
        
        if propertyValue.count <= maxUserPropertyValueLength {
            return ValidationResult.valid(propertyValue)
        }
        
        let truncated = String(propertyValue.prefix(maxUserPropertyValueLength))
        return ValidationResult.sanitized(propertyValue, truncated, "User property value truncated to \(maxUserPropertyValueLength) characters")
    }
    
    /**
     * Common validation logic for Firebase names (events and parameters)
     * Always returns a valid Firebase-compatible name
     * 
     * @param name The name to validate
     * @param invalidFallback Fallback name for invalid cases
     * @param sanitizationPrefix Prefix to add if name doesn't start with letter
     * @param nameType Type description for error messages
     * @return ValidationResult with original and sanitized values
     */
    private static func validateName(_ name: String?, invalidFallback: String, sanitizationPrefix: String, nameType: String) -> ValidationResult {
        do {
            guard let name = name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return ValidationResult.invalid(name, invalidFallback, "Empty \(nameType.lowercased())")
            }
            
            // Quick check: if already valid, return as-is
            if name.matches(namePattern) {
                return ValidationResult.valid(name)
            }
            
            // Try to sanitize - if it's only a reserved prefix, it's invalid
            let sanitized = try sanitizeName(name, fallbackPrefix: sanitizationPrefix)
            
            // Compare and return result
            if name == sanitized {
                return ValidationResult.valid(sanitized)
            } else {
                return ValidationResult.sanitized(name, sanitized, "\(nameType) sanitized")
            }
        } catch let error as FirebaseValidationException {
            return ValidationResult.invalid(name, invalidFallback, error.message)
        } catch {
            return ValidationResult.invalid(name, invalidFallback, "Unknown validation error")
        }
    }
    
    /**
     * Validation logic for Firebase user property names (different length limits)
     * Always returns a valid Firebase-compatible user property name
     * 
     * @param name The user property name to validate
     * @param invalidFallback Fallback name for invalid cases
     * @param sanitizationPrefix Prefix to add if name doesn't start with letter
     * @param nameType Type description for error messages
     * @return ValidationResult with original and sanitized values
     */
    private static func validateUserPropertyNameInternal(_ name: String?, invalidFallback: String, sanitizationPrefix: String, nameType: String) -> ValidationResult {
        do {
            guard let name = name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return ValidationResult.invalid(name, invalidFallback, "Empty \(nameType.lowercased())")
            }
            
            // Quick check: if already valid, return as-is
            if name.matches(userPropertyNamePattern) {
                return ValidationResult.valid(name)
            }
            
            // Try to sanitize - if it's only a reserved prefix, it's invalid
            let sanitized = try sanitizeUserPropertyName(name, fallbackPrefix: sanitizationPrefix)
            
            // Compare and return result
            if name == sanitized {
                return ValidationResult.valid(sanitized)
            } else {
                return ValidationResult.sanitized(name, sanitized, "\(nameType) sanitized")
            }
        } catch let error as FirebaseValidationException {
            return ValidationResult.invalid(name, invalidFallback, error.message)
        } catch {
            return ValidationResult.invalid(name, invalidFallback, "Unknown validation error")
        }
    }
    
    /**
     * Sanitizes Firebase name (event or parameter) to be Firebase-compatible
     * Steps: remove reserved prefixes → replace invalid chars → clean underscores → ensure letter start → truncate
     * 
     * @param name The name to sanitize
     * @param fallbackPrefix Prefix to add if name doesn't start with letter (e.g., "event_", "param_")
     * @return Firebase-compatible name
     * @throws FirebaseValidationException if name is only a reserved prefix
     */
    private static func sanitizeName(_ name: String, fallbackPrefix: String) throws -> String {
        
        // Step 1: Remove reserved prefixes
        var result = try removeReservedPrefixes(name)
        
        // Step 2: Handle invalid characters based on strategy
        if invalidCharStrategy == strategyReplace {
            // Replace invalid characters with underscore
            result = result.replacingOccurrences(of: "[^a-zA-Z0-9_]", with: "_", options: .regularExpression)
        } else {
            // Remove invalid characters completely
            result = result.replacingOccurrences(of: "[^a-zA-Z0-9_]", with: "", options: .regularExpression)
        }
        
        // Step 3: Clean up multiple underscores
        result = result.replacingOccurrences(of: "_+", with: "_", options: .regularExpression)
        
        // Step 4: Remove leading/trailing underscores
        result = result.replacingOccurrences(of: "^_+|_+$", with: "", options: .regularExpression)
        
        // Step 5: Ensure starts with a letter (only if needed after cleanup)
        if result.isEmpty || !result.first!.isLetter {
            result = fallbackPrefix + result
        }
        
        // Step 6: Truncate if too long
        if result.count > maxNameLength {
            result = String(result.prefix(maxNameLength))
        }
        
        // Step 7: Final fallback if somehow still empty
        if result.isEmpty {
            result = fallbackPrefix.replacingOccurrences(of: "_", with: "") + "_fallback"
        }
        
        return result
    }
    
    /**
     * Sanitizes Firebase user property name to be Firebase-compatible (24 char limit)
     * Steps: remove reserved prefixes → replace invalid chars → clean underscores → ensure letter start → truncate
     * 
     * @param name The user property name to sanitize
     * @param fallbackPrefix Prefix to add if name doesn't start with letter (e.g., "prop_")
     * @return Firebase-compatible user property name
     * @throws FirebaseValidationException if name is only a reserved prefix
     */
    private static func sanitizeUserPropertyName(_ name: String, fallbackPrefix: String) throws -> String {
        
        // Step 1: Remove reserved prefixes
        var result = try removeReservedPrefixes(name)
        
        // Step 2: Handle invalid characters based on strategy
        if invalidCharStrategy == strategyReplace {
            // Replace invalid characters with underscore
            result = result.replacingOccurrences(of: "[^a-zA-Z0-9_]", with: "_", options: .regularExpression)
        } else {
            // Remove invalid characters completely
            result = result.replacingOccurrences(of: "[^a-zA-Z0-9_]", with: "", options: .regularExpression)
        }
        
        // Step 3: Clean up multiple underscores
        result = result.replacingOccurrences(of: "_+", with: "_", options: .regularExpression)
        
        // Step 4: Remove leading/trailing underscores
        result = result.replacingOccurrences(of: "^_+|_+$", with: "", options: .regularExpression)
        
        // Step 5: Ensure starts with a letter (only if needed after cleanup)
        if result.isEmpty || !result.first!.isLetter {
            result = fallbackPrefix + result
        }
        
        // Step 6: Truncate if too long (24 chars for user properties)
        if result.count > maxUserPropertyNameLength {
            result = String(result.prefix(maxUserPropertyNameLength))
        }
        
        // Step 7: Final fallback if somehow still empty
        if result.isEmpty {
            result = fallbackPrefix.replacingOccurrences(of: "_", with: "") + "_fallback"
        }
        
        return result
    }
    
    /**
     * Removes reserved Firebase prefixes from name
     * 
     * @param name The name to process (event name or parameter name)
     * @return Name without reserved prefixes  
     * @throws FirebaseValidationException if name is only a reserved prefix
     */
    private static func removeReservedPrefixes(_ name: String) throws -> String {
        let lower = name.lowercased()
        var result = name
        
        if lower.hasPrefix("firebase_") {
            result = String(name.dropFirst(9)) // Remove "firebase_"
        } else if lower.hasPrefix("google_") {
            result = String(name.dropFirst(7))  // Remove "google_"
        } else if lower.hasPrefix("ga_") {
            result = String(name.dropFirst(3))  // Remove "ga_"
        }
        
        // If removing prefix left us with empty string, this is invalid input
        if result.isEmpty {
            throw FirebaseValidationException("Name cannot be only a reserved prefix: \(name)")
        }
        
        return result
    }
}

// MARK: - String Extension for Regex Matching
extension String {
    func matches(_ pattern: String) -> Bool {
        return self.range(of: pattern, options: .regularExpression) != nil
    }
} 