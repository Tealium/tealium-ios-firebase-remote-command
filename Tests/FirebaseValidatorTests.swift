//
//  FirebaseValidatorTests.swift
//  TealiumFirebaseTests
//
//  Created by Assistant on 12/16/24.
//  Copyright © 2024 Tealium. All rights reserved.
//

import XCTest
@testable import TealiumFirebase

final class FirebaseValidatorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Reset to default strategy before each test
        FirebaseValidator.setInvalidCharStrategy(FirebaseValidator.strategyReplace)
        FirebaseValidator.setGA360Mode(false)
    }

    // MARK: - Event Name Validation Tests
    
    func testValidateEventName_ValidName_ReturnsValid() {
        // Valid event name: alphanumeric, starts with letter, <= 40 chars, no reserved prefix
        let result = FirebaseValidator.validateEventName("valid_event_name")
        
        XCTAssertTrue(result.isValid, "Valid event name should be accepted")
        XCTAssertFalse(result.isSanitized(), "Valid event name should not be sanitized")
        XCTAssertEqual("valid_event_name", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("valid_event_name", result.sanitizedValue, "Sanitized value should be same as original")
    }

    func testValidateEventName_NameWithInvalidCharacters_ReplaceStrategy_SanitizesCorrectly() {
        // Event name with invalid characters: space, hyphen, special characters
        FirebaseValidator.setInvalidCharStrategy(FirebaseValidator.strategyReplace)
        
        let result = FirebaseValidator.validateEventName("my-event name!")
        
        XCTAssertTrue(result.isValid, "Event name with invalid chars should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Event name should be marked as sanitized")
        XCTAssertEqual("my-event name!", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("my_event_name", result.sanitizedValue, "Invalid chars should be replaced with underscores")
        XCTAssertEqual("Event name sanitized", result.errorMessage, "Error message should indicate sanitization")
    }

    func testValidateEventName_NameWithInvalidCharacters_RemoveStrategy_SanitizesCorrectly() {
        // Event name with invalid characters using remove strategy
        FirebaseValidator.setInvalidCharStrategy(FirebaseValidator.strategyRemove)
        
        let result = FirebaseValidator.validateEventName("my-event name!")
        
        XCTAssertTrue(result.isValid, "Event name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Event name should be marked as sanitized")
        XCTAssertEqual("my-event name!", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("myeventname", result.sanitizedValue, "Invalid chars should be removed")
        XCTAssertEqual("Event name sanitized", result.errorMessage, "Error message should indicate sanitization")
    }

    func testValidateEventName_NameStartingWithDigit_AddsPrefixCorrectly() {
        // Event name starting with digit should be prefixed
        let result = FirebaseValidator.validateEventName("123event")
        
        XCTAssertTrue(result.isValid, "Event name starting with digit should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Event name should be marked as sanitized")
        XCTAssertEqual("123event", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("event_123event", result.sanitizedValue, "Prefix should be added")
        XCTAssertEqual("Event name sanitized", result.errorMessage, "Error message should indicate sanitization")
    }

    func testValidateEventName_NameWithFirebasePrefix_RemovesPrefixCorrectly() {
        // Event name with firebase_ prefix should have prefix removed
        let result = FirebaseValidator.validateEventName("firebase_test_event")
        
        XCTAssertTrue(result.isValid, "Event name with firebase prefix should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Event name should be marked as sanitized")
        XCTAssertEqual("firebase_test_event", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("test_event", result.sanitizedValue, "Firebase prefix should be removed")
        XCTAssertEqual("Event name sanitized", result.errorMessage, "Error message should indicate sanitization")
    }

    func testValidateEventName_NameWithGooglePrefix_RemovesPrefixCorrectly() {
        // Event name with google_ prefix should have prefix removed
        let result = FirebaseValidator.validateEventName("google_test_event")
        
        XCTAssertTrue(result.isValid, "Event name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Event name should be marked as sanitized")
        XCTAssertEqual("google_test_event", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("test_event", result.sanitizedValue, "Google prefix should be removed")
    }

    func testValidateEventName_NameWithGaPrefix_RemovesPrefixCorrectly() {
        // Event name with ga_ prefix should have prefix removed
        let result = FirebaseValidator.validateEventName("ga_test_event")
        
        XCTAssertTrue(result.isValid, "Event name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Event name should be marked as sanitized")
        XCTAssertEqual("ga_test_event", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("test_event", result.sanitizedValue, "GA prefix should be removed")
    }

    func testValidateEventName_NameLongerThan40Chars_TruncatesCorrectly() {
        // Event name longer than 40 characters should be truncated
        let longName = "this_is_a_very_long_event_name_that_exceeds_forty_characters"
        let result = FirebaseValidator.validateEventName(longName)
        
        XCTAssertTrue(result.isValid, "Long event name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Event name should be marked as sanitized")
        XCTAssertEqual(longName, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(40, result.sanitizedValue?.count, "Name should be truncated to 40 chars")
        XCTAssertEqual("this_is_a_very_long_event_name_that_exce", result.sanitizedValue, "Truncated name should match expected")
    }

    func testValidateEventName_OnlyFirebasePrefix_ReturnsInvalid() {
        // Event name that is only a reserved prefix should be invalid
        let result = FirebaseValidator.validateEventName("firebase_")
        
        XCTAssertFalse(result.isValid, "Event name that is only firebase prefix should be invalid")
        XCTAssertFalse(result.isSanitized(), "Invalid event should not be marked as sanitized")
        XCTAssertEqual("firebase_", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("invalid_event", result.sanitizedValue, "Fallback name should be used")
        XCTAssertTrue(result.errorMessage.contains("Name cannot be only a reserved prefix"), "Error message should mention reserved prefix")
    }

    func testValidateEventName_OnlyGooglePrefix_ReturnsInvalid() {
        // Event name that is only google_ should be invalid
        let result = FirebaseValidator.validateEventName("google_")
        
        XCTAssertFalse(result.isValid, "Event name that is only google prefix should be invalid")
        XCTAssertEqual("invalid_event", result.sanitizedValue, "Fallback name should be used")
        XCTAssertTrue(result.errorMessage.contains("Name cannot be only a reserved prefix"), "Error message should mention reserved prefix")
    }

    func testValidateEventName_OnlyGaPrefix_ReturnsInvalid() {
        // Event name that is only ga_ should be invalid
        let result = FirebaseValidator.validateEventName("ga_")
        
        XCTAssertFalse(result.isValid, "Event name that is only ga prefix should be invalid")
        XCTAssertEqual("invalid_event", result.sanitizedValue, "Fallback name should be used")
        XCTAssertTrue(result.errorMessage.contains("Name cannot be only a reserved prefix"), "Error message should mention reserved prefix")
    }

    func testValidateEventName_EmptyName_ReturnsInvalid() {
        // Empty event name should be invalid
        let result = FirebaseValidator.validateEventName("")
        
        XCTAssertFalse(result.isValid, "Empty event name should be invalid")
        XCTAssertFalse(result.isSanitized(), "Invalid event should not be marked as sanitized")
        XCTAssertEqual("", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("invalid_event", result.sanitizedValue, "Fallback name should be used")
        XCTAssertEqual("Empty event name", result.errorMessage, "Error message should mention empty name")
    }

    func testValidateEventName_NullName_ReturnsInvalid() {
        // Null event name should be invalid
        let result = FirebaseValidator.validateEventName(nil)

        XCTAssertFalse(result.isValid, "Null event name should be invalid")
        XCTAssertFalse(result.isSanitized(), "Invalid event should not be marked as sanitized")
        XCTAssertNil(result.originalValue, "Original value should be preserved")
        XCTAssertEqual("invalid_event", result.sanitizedValue, "Fallback name should be used")
        XCTAssertEqual("Empty event name", result.errorMessage, "Error message should mention empty name")
    }

    func testValidateEventName_WhitespaceOnlyName_ReturnsInvalid() {
        // Event name with only whitespace should be invalid
        let result = FirebaseValidator.validateEventName("   ")

        XCTAssertFalse(result.isValid, "Whitespace-only event name should be invalid")
        XCTAssertEqual("invalid_event", result.sanitizedValue, "Fallback name should be used")
        XCTAssertEqual("Empty event name", result.errorMessage, "Error message should mention empty name")
    }

    func testValidateEventName_ComplexScenario_SanitizesCorrectly() {
        // Complex scenario: firebase prefix + invalid chars + too long
        let complexName = "firebase_my-complex event@name#with$special%chars_that_is_way_too_long_for_firebase_limits"
        let result = FirebaseValidator.validateEventName(complexName)

        XCTAssertTrue(result.isValid, "Complex event name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Event name should be marked as sanitized")
        XCTAssertEqual(complexName, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(40, result.sanitizedValue?.count, "Result should be valid length")
        XCTAssertTrue(result.sanitizedValue?.first?.isLetter ?? false, "Result should start with letter")
        XCTAssertTrue(result.sanitizedValue?.range(of: "^[a-zA-Z][a-zA-Z0-9_]*$", options: .regularExpression) != nil, "Result should not contain invalid chars")
        XCTAssertFalse(result.sanitizedValue?.hasPrefix("firebase_") ?? true, "Result should not contain firebase prefix")
    }

    // MARK: - Parameter Name Validation Tests

    func testValidateParameterName_ValidName_ReturnsValid() {
        // Valid parameter name: alphanumeric, starts with letter, <= 40 chars, no reserved prefix
        let result = FirebaseValidator.validateParameterName("valid_param_name")

        XCTAssertTrue(result.isValid, "Valid parameter name should be accepted")
        XCTAssertFalse(result.isSanitized(), "Valid parameter name should not be sanitized")
        XCTAssertEqual("valid_param_name", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("valid_param_name", result.sanitizedValue, "Sanitized value should be same as original")
    }

    func testValidateParameterName_NameWithInvalidCharacters_ReplaceStrategy_SanitizesCorrectly() {
        // Parameter name with invalid characters: space, hyphen, special characters
        FirebaseValidator.setInvalidCharStrategy(FirebaseValidator.strategyReplace)

        let result = FirebaseValidator.validateParameterName("my-param name!")

        XCTAssertTrue(result.isValid, "Parameter name with invalid chars should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Parameter name should be marked as sanitized")
        XCTAssertEqual("my-param name!", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("my_param_name", result.sanitizedValue, "Invalid chars should be replaced with underscores")
        XCTAssertEqual("Parameter name sanitized", result.errorMessage, "Error message should indicate sanitization")
    }

    func testValidateParameterName_NameWithInvalidCharacters_RemoveStrategy_SanitizesCorrectly() {
        // Parameter name with invalid characters using remove strategy
        FirebaseValidator.setInvalidCharStrategy(FirebaseValidator.strategyRemove)

        let result = FirebaseValidator.validateParameterName("my-param name!")

        XCTAssertTrue(result.isValid, "Parameter name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Parameter name should be marked as sanitized")
        XCTAssertEqual("my-param name!", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("myparamname", result.sanitizedValue, "Invalid chars should be removed")
        XCTAssertEqual("Parameter name sanitized", result.errorMessage, "Error message should indicate sanitization")
    }

    func testValidateParameterName_NameStartingWithDigit_AddsPrefixCorrectly() {
        // Parameter name starting with digit should be prefixed
        let result = FirebaseValidator.validateParameterName("123param")

        XCTAssertTrue(result.isValid, "Parameter name starting with digit should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Parameter name should be marked as sanitized")
        XCTAssertEqual("123param", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("param_123param", result.sanitizedValue, "Prefix should be added")
        XCTAssertEqual("Parameter name sanitized", result.errorMessage, "Error message should indicate sanitization")
    }

    func testValidateParameterName_NameWithFirebasePrefix_RemovesPrefixCorrectly() {
        // Parameter name with firebase_ prefix should have prefix removed
        let result = FirebaseValidator.validateParameterName("firebase_test_param")

        XCTAssertTrue(result.isValid, "Parameter name with firebase prefix should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Parameter name should be marked as sanitized")
        XCTAssertEqual("firebase_test_param", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("test_param", result.sanitizedValue, "Firebase prefix should be removed")
        XCTAssertEqual("Parameter name sanitized", result.errorMessage, "Error message should indicate sanitization")
    }

    func testValidateParameterName_NameWithGooglePrefix_RemovesPrefixCorrectly() {
        // Parameter name with google_ prefix should have prefix removed
        let result = FirebaseValidator.validateParameterName("google_test_param")

        XCTAssertTrue(result.isValid, "Parameter name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Parameter name should be marked as sanitized")
        XCTAssertEqual("google_test_param", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("test_param", result.sanitizedValue, "Google prefix should be removed")
    }

    func testValidateParameterName_NameWithGaPrefix_RemovesPrefixCorrectly() {
        // Parameter name with ga_ prefix should have prefix removed
        let result = FirebaseValidator.validateParameterName("ga_test_param")

        XCTAssertTrue(result.isValid, "Parameter name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Parameter name should be marked as sanitized")
        XCTAssertEqual("ga_test_param", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("test_param", result.sanitizedValue, "GA prefix should be removed")
    }

    func testValidateParameterName_NameLongerThan40Chars_TruncatesCorrectly() {
        // Parameter name longer than 40 characters should be truncated
        let longName = "this_is_a_very_long_parameter_name_that_exceeds_forty_characters"
        let result = FirebaseValidator.validateParameterName(longName)

        XCTAssertTrue(result.isValid, "Long parameter name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Parameter name should be marked as sanitized")
        XCTAssertEqual(longName, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(40, result.sanitizedValue?.count, "Name should be truncated to 40 chars")
        XCTAssertEqual("this_is_a_very_long_parameter_name_that_", result.sanitizedValue, "Truncated name should match expected")
    }

    func testValidateParameterName_OnlyFirebasePrefix_ReturnsInvalid() {
        // Parameter name that is only a reserved prefix should be invalid
        let result = FirebaseValidator.validateParameterName("firebase_")

        XCTAssertFalse(result.isValid, "Parameter name that is only firebase prefix should be invalid")
        XCTAssertFalse(result.isSanitized(), "Invalid parameter should not be marked as sanitized")
        XCTAssertEqual("firebase_", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("invalid_param", result.sanitizedValue, "Fallback name should be used")
        XCTAssertTrue(result.errorMessage.contains("Name cannot be only a reserved prefix"), "Error message should mention reserved prefix")
    }

    func testValidateParameterName_OnlyGooglePrefix_ReturnsInvalid() {
        // Parameter name that is only google_ should be invalid
        let result = FirebaseValidator.validateParameterName("google_")

        XCTAssertFalse(result.isValid, "Parameter name that is only google prefix should be invalid")
        XCTAssertEqual("invalid_param", result.sanitizedValue, "Fallback name should be used")
        XCTAssertTrue(result.errorMessage.contains("Name cannot be only a reserved prefix"), "Error message should mention reserved prefix")
    }

    func testValidateParameterName_OnlyGaPrefix_ReturnsInvalid() {
        // Parameter name that is only ga_ should be invalid
        let result = FirebaseValidator.validateParameterName("ga_")

        XCTAssertFalse(result.isValid, "Parameter name that is only ga prefix should be invalid")
        XCTAssertEqual("invalid_param", result.sanitizedValue, "Fallback name should be used")
        XCTAssertTrue(result.errorMessage.contains("Name cannot be only a reserved prefix"), "Error message should mention reserved prefix")
    }

    func testValidateParameterName_EmptyName_ReturnsInvalid() {
        // Empty parameter name should be invalid
        let result = FirebaseValidator.validateParameterName("")

        XCTAssertFalse(result.isValid, "Empty parameter name should be invalid")
        XCTAssertFalse(result.isSanitized(), "Invalid parameter should not be marked as sanitized")
        XCTAssertEqual("", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("invalid_param", result.sanitizedValue, "Fallback name should be used")
        XCTAssertEqual("Empty parameter name", result.errorMessage, "Error message should mention empty name")
    }

    func testValidateParameterName_NullName_ReturnsInvalid() {
        // Null parameter name should be invalid
        let result = FirebaseValidator.validateParameterName(nil)

        XCTAssertFalse(result.isValid, "Null parameter name should be invalid")
        XCTAssertFalse(result.isSanitized(), "Invalid parameter should not be marked as sanitized")
        XCTAssertNil(result.originalValue, "Original value should be preserved")
        XCTAssertEqual("invalid_param", result.sanitizedValue, "Fallback name should be used")
        XCTAssertEqual("Empty parameter name", result.errorMessage, "Error message should mention empty name")
    }

    func testValidateParameterName_WhitespaceOnlyName_ReturnsInvalid() {
        // Parameter name with only whitespace should be invalid
        let result = FirebaseValidator.validateParameterName("   ")

        XCTAssertFalse(result.isValid, "Whitespace-only parameter name should be invalid")
        XCTAssertEqual("invalid_param", result.sanitizedValue, "Fallback name should be used")
        XCTAssertEqual("Empty parameter name", result.errorMessage, "Error message should mention empty name")
    }

    func testValidateParameterName_ComplexScenario_SanitizesCorrectly() {
        // Complex scenario: firebase prefix + invalid chars + too long
        let complexName = "firebase_my-complex param@name#with$special%chars_that_is_way_too_long_for_firebase_limits"
        let result = FirebaseValidator.validateParameterName(complexName)

        XCTAssertTrue(result.isValid, "Complex parameter name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Parameter name should be marked as sanitized")
        XCTAssertEqual(complexName, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(40, result.sanitizedValue?.count, "Result should be valid length")
        XCTAssertTrue(result.sanitizedValue?.first?.isLetter ?? false, "Result should start with letter")
        XCTAssertTrue(result.sanitizedValue?.range(of: "^[a-zA-Z][a-zA-Z0-9_]*$", options: .regularExpression) != nil, "Result should not contain invalid chars")
        XCTAssertFalse(result.sanitizedValue?.hasPrefix("firebase_") ?? true, "Result should not contain firebase prefix")
    }

    // MARK: - Parameter Value Validation Tests

    func testValidateParameterValue_ValueWithin100Chars_ReturnsValid() {
        // Parameter value with exactly 100 characters (standard limit)
        let exactlyHundredChars = String(repeating: "a", count: 100)
        XCTAssertEqual(100, exactlyHundredChars.count, "Test string should be exactly 100 chars")

        let result = FirebaseValidator.validateParameterValue(exactlyHundredChars)

        XCTAssertTrue(result.isValid, "Parameter value within 100 chars should be valid")
        XCTAssertFalse(result.isSanitized(), "Parameter value should not be sanitized")
        XCTAssertEqual(exactlyHundredChars, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(exactlyHundredChars, result.sanitizedValue, "Sanitized value should be same as original")
        XCTAssertEqual("Valid", result.errorMessage, "Error message should indicate valid")
    }

    func testValidateParameterValue_ValueOver100Chars_StandardMode_TruncatesCorrectly() {
        // Parameter value with 101 characters (should be truncated to 100 in standard mode)
        let hundredOneChars = String(repeating: "a", count: 101)
        XCTAssertEqual(101, hundredOneChars.count, "Test string should be exactly 101 chars")

        // Ensure we're in standard mode (not GA360)
        FirebaseValidator.setGA360Mode(false)

        let result = FirebaseValidator.validateParameterValue(hundredOneChars)

        XCTAssertTrue(result.isValid, "Parameter value should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Parameter value should be marked as sanitized")
        XCTAssertEqual(hundredOneChars, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(100, result.sanitizedValue?.count, "Value should be truncated to 100 chars")
        XCTAssertEqual(String(hundredOneChars.prefix(100)), result.sanitizedValue, "Truncated value should match expected")
        XCTAssertEqual("Parameter value truncated to 100 characters", result.errorMessage, "Error message should indicate truncation")
    }

    func testValidateParameterValue_ValueOver500Chars_GA360Mode_TruncatesCorrectly() {
        // Parameter value with 501 characters (should be truncated to 500 in GA360 mode)
        let fiveHundredOneChars = String(repeating: "a", count: 501)
        XCTAssertEqual(501, fiveHundredOneChars.count, "Test string should be exactly 501 chars")

        // Enable GA360 mode for 500 char limit
        FirebaseValidator.setGA360Mode(true)

        let result = FirebaseValidator.validateParameterValue(fiveHundredOneChars)

        XCTAssertTrue(result.isValid, "Parameter value should be sanitized")
        XCTAssertTrue(result.isSanitized(), "Parameter value should be marked as sanitized")
        XCTAssertEqual(fiveHundredOneChars, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(500, result.sanitizedValue?.count, "Value should be truncated to 500 chars")
        XCTAssertEqual(String(fiveHundredOneChars.prefix(500)), result.sanitizedValue, "Truncated value should match expected")
        XCTAssertEqual("Parameter value truncated to 500 characters", result.errorMessage, "Error message should indicate truncation")
    }

    func testValidateParameterValue_ValueExactly500Chars_GA360Mode_ReturnsValid() {
        // Parameter value with exactly 500 characters (GA360 limit)
        let exactlyFiveHundredChars = String(repeating: "a", count: 500)
        XCTAssertEqual(500, exactlyFiveHundredChars.count, "Test string should be exactly 500 chars")

        // Enable GA360 mode for 500 char limit
        FirebaseValidator.setGA360Mode(true)

        let result = FirebaseValidator.validateParameterValue(exactlyFiveHundredChars)

        XCTAssertTrue(result.isValid, "Parameter value within 500 chars should be valid")
        XCTAssertFalse(result.isSanitized(), "Parameter value should not be sanitized")
        XCTAssertEqual(exactlyFiveHundredChars, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(exactlyFiveHundredChars, result.sanitizedValue, "Sanitized value should be same as original")
        XCTAssertEqual("Valid", result.errorMessage, "Error message should indicate valid")
    }

    func testValidateParameterValue_NullValue_ReturnsValid() {
        // Null parameter value should be handled gracefully
        let result = FirebaseValidator.validateParameterValue(nil)

        XCTAssertTrue(result.isValid, "Null parameter value should be valid")
        XCTAssertFalse(result.isSanitized(), "Null value should not be marked as sanitized")
        XCTAssertNil(result.originalValue, "Original value should be nil")
        XCTAssertNil(result.sanitizedValue, "Sanitized value should be nil")
        XCTAssertEqual("Valid", result.errorMessage, "Error message should indicate valid")
    }

    func testValidateParameterValue_EmptyString_ReturnsValid() {
        // Empty parameter value should be valid
        let result = FirebaseValidator.validateParameterValue("")

        XCTAssertTrue(result.isValid, "Empty parameter value should be valid")
        XCTAssertFalse(result.isSanitized(), "Empty value should not be marked as sanitized")
        XCTAssertEqual("", result.originalValue, "Original value should be empty")
        XCTAssertEqual("", result.sanitizedValue, "Sanitized value should be empty")
        XCTAssertEqual("Valid", result.errorMessage, "Error message should indicate valid")
    }

    func testValidateParameterValue_ShortValue_ReturnsValid() {
        // Short parameter value should be valid
        let shortValue = "short"
        let result = FirebaseValidator.validateParameterValue(shortValue)

        XCTAssertTrue(result.isValid, "Short parameter value should be valid")
        XCTAssertFalse(result.isSanitized(), "Short value should not be marked as sanitized")
        XCTAssertEqual(shortValue, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(shortValue, result.sanitizedValue, "Sanitized value should be same as original")
        XCTAssertEqual("Valid", result.errorMessage, "Error message should indicate valid")
    }

    func testValidateParameterValue_GA360ModeSwitch_BehavesCorrectly() {
        // Test switching between standard and GA360 modes
        let longValue = String(repeating: "a", count: 150)
        XCTAssertEqual(150, longValue.count, "Test string should be exactly 150 chars")

        // Test in standard mode (100 char limit)
        FirebaseValidator.setGA360Mode(false)
        let standardResult = FirebaseValidator.validateParameterValue(longValue)

        XCTAssertTrue(standardResult.isSanitized(), "Value should be truncated in standard mode")
        XCTAssertEqual(100, standardResult.sanitizedValue?.count, "Value should be truncated to 100 chars in standard mode")

        // Test in GA360 mode (500 char limit)
        FirebaseValidator.setGA360Mode(true)
        let ga360Result = FirebaseValidator.validateParameterValue(longValue)

        XCTAssertFalse(ga360Result.isSanitized(), "Value should not be truncated in GA360 mode")
        XCTAssertEqual(150, ga360Result.sanitizedValue?.count, "Value should remain 150 chars in GA360 mode")
        XCTAssertEqual(longValue, ga360Result.sanitizedValue, "Original value should be preserved in GA360 mode")
    }

    // MARK: - User Property Name Validation Tests

    func testValidateUserPropertyName_ValidName_ReturnsValid() {
        // Valid user property name: alphanumeric, starts with letter, <= 24 chars, no reserved prefix
        let result = FirebaseValidator.validateUserPropertyName("valid_user_prop")

        XCTAssertTrue(result.isValid, "Valid user property name should be accepted")
        XCTAssertFalse(result.isSanitized(), "Valid user property name should not be sanitized")
        XCTAssertEqual("valid_user_prop", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("valid_user_prop", result.sanitizedValue, "Sanitized value should be same as original")
    }

    func testValidateUserPropertyName_NameWithInvalidCharacters_ReplaceStrategy_SanitizesCorrectly() {
        // User property name with invalid characters: space, hyphen, special characters
        FirebaseValidator.setInvalidCharStrategy(FirebaseValidator.strategyReplace)

        let result = FirebaseValidator.validateUserPropertyName("my-user prop!")

        XCTAssertTrue(result.isValid, "User property name with invalid chars should be sanitized")
        XCTAssertTrue(result.isSanitized(), "User property name should be marked as sanitized")
        XCTAssertEqual("my-user prop!", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("my_user_prop", result.sanitizedValue, "Invalid chars should be replaced with underscores")
        XCTAssertEqual("User property name sanitized", result.errorMessage, "Error message should indicate sanitization")
    }

    func testValidateUserPropertyName_NameWithInvalidCharacters_RemoveStrategy_SanitizesCorrectly() {
        // User property name with invalid characters using remove strategy
        FirebaseValidator.setInvalidCharStrategy(FirebaseValidator.strategyRemove)

        let result = FirebaseValidator.validateUserPropertyName("my-user prop!")

        XCTAssertTrue(result.isValid, "User property name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "User property name should be marked as sanitized")
        XCTAssertEqual("my-user prop!", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("myuserprop", result.sanitizedValue, "Invalid chars should be removed")
        XCTAssertEqual("User property name sanitized", result.errorMessage, "Error message should indicate sanitization")
    }

    func testValidateUserPropertyName_NameStartingWithDigit_AddsPrefixCorrectly() {
        // User property name starting with digit should be prefixed
        let result = FirebaseValidator.validateUserPropertyName("123user")

        XCTAssertTrue(result.isValid, "User property name starting with digit should be sanitized")
        XCTAssertTrue(result.isSanitized(), "User property name should be marked as sanitized")
        XCTAssertEqual("123user", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("prop_123user", result.sanitizedValue, "Prefix should be added")
        XCTAssertEqual("User property name sanitized", result.errorMessage, "Error message should indicate sanitization")
    }

    func testValidateUserPropertyName_NameWithFirebasePrefix_RemovesPrefixCorrectly() {
        // User property name with firebase_ prefix should have prefix removed
        let result = FirebaseValidator.validateUserPropertyName("firebase_test_user")

        XCTAssertTrue(result.isValid, "User property name with firebase prefix should be sanitized")
        XCTAssertTrue(result.isSanitized(), "User property name should be marked as sanitized")
        XCTAssertEqual("firebase_test_user", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("test_user", result.sanitizedValue, "Firebase prefix should be removed")
        XCTAssertEqual("User property name sanitized", result.errorMessage, "Error message should indicate sanitization")
    }

    func testValidateUserPropertyName_NameWithGooglePrefix_RemovesPrefixCorrectly() {
        // User property name with google_ prefix should have prefix removed
        let result = FirebaseValidator.validateUserPropertyName("google_test_user")

        XCTAssertTrue(result.isValid, "User property name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "User property name should be marked as sanitized")
        XCTAssertEqual("google_test_user", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("test_user", result.sanitizedValue, "Google prefix should be removed")
    }

    func testValidateUserPropertyName_NameWithGaPrefix_RemovesPrefixCorrectly() {
        // User property name with ga_ prefix should have prefix removed
        let result = FirebaseValidator.validateUserPropertyName("ga_test_user")

        XCTAssertTrue(result.isValid, "User property name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "User property name should be marked as sanitized")
        XCTAssertEqual("ga_test_user", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("test_user", result.sanitizedValue, "GA prefix should be removed")
    }

    func testValidateUserPropertyName_NameLongerThan24Chars_TruncatesCorrectly() {
        // User property name longer than 24 characters should be truncated (not 40!)
        let longName = "this_is_very_long_user_property_name"
        XCTAssertEqual(36, longName.count, "Test string should be longer than 24 chars")

        let result = FirebaseValidator.validateUserPropertyName(longName)

        XCTAssertTrue(result.isValid, "Long user property name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "User property name should be marked as sanitized")
        XCTAssertEqual(longName, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(24, result.sanitizedValue?.count, "Name should be truncated to 24 chars")
        XCTAssertEqual("this_is_very_long_user_p", result.sanitizedValue, "Truncated name should match expected")
    }

    func testValidateUserPropertyName_OnlyFirebasePrefix_ReturnsInvalid() {
        // User property name that is only a reserved prefix should be invalid
        let result = FirebaseValidator.validateUserPropertyName("firebase_")

        XCTAssertFalse(result.isValid, "User property name that is only firebase prefix should be invalid")
        XCTAssertFalse(result.isSanitized(), "Invalid user property should not be marked as sanitized")
        XCTAssertEqual("firebase_", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("invalid_property", result.sanitizedValue, "Fallback name should be used")
        XCTAssertTrue(result.errorMessage.contains("Name cannot be only a reserved prefix"), "Error message should mention reserved prefix")
    }

    func testValidateUserPropertyName_OnlyGooglePrefix_ReturnsInvalid() {
        // User property name that is only google_ should be invalid
        let result = FirebaseValidator.validateUserPropertyName("google_")

        XCTAssertFalse(result.isValid, "User property name that is only google prefix should be invalid")
        XCTAssertEqual("invalid_property", result.sanitizedValue, "Fallback name should be used")
        XCTAssertTrue(result.errorMessage.contains("Name cannot be only a reserved prefix"), "Error message should mention reserved prefix")
    }

    func testValidateUserPropertyName_OnlyGaPrefix_ReturnsInvalid() {
        // User property name that is only ga_ should be invalid
        let result = FirebaseValidator.validateUserPropertyName("ga_")

        XCTAssertFalse(result.isValid, "User property name that is only ga prefix should be invalid")
        XCTAssertEqual("invalid_property", result.sanitizedValue, "Fallback name should be used")
        XCTAssertTrue(result.errorMessage.contains("Name cannot be only a reserved prefix"), "Error message should mention reserved prefix")
    }

    func testValidateUserPropertyName_EmptyName_ReturnsInvalid() {
        // Empty user property name should be invalid
        let result = FirebaseValidator.validateUserPropertyName("")

        XCTAssertFalse(result.isValid, "Empty user property name should be invalid")
        XCTAssertFalse(result.isSanitized(), "Invalid user property should not be marked as sanitized")
        XCTAssertEqual("", result.originalValue, "Original value should be preserved")
        XCTAssertEqual("invalid_property", result.sanitizedValue, "Fallback name should be used")
        XCTAssertEqual("Empty user property name", result.errorMessage, "Error message should mention empty name")
    }

    func testValidateUserPropertyName_NullName_ReturnsInvalid() {
        // Null user property name should be invalid
        let result = FirebaseValidator.validateUserPropertyName(nil)

        XCTAssertFalse(result.isValid, "Null user property name should be invalid")
        XCTAssertFalse(result.isSanitized(), "Invalid user property should not be marked as sanitized")
        XCTAssertNil(result.originalValue, "Original value should be preserved")
        XCTAssertEqual("invalid_property", result.sanitizedValue, "Fallback name should be used")
        XCTAssertEqual("Empty user property name", result.errorMessage, "Error message should mention empty name")
    }

    func testValidateUserPropertyName_WhitespaceOnlyName_ReturnsInvalid() {
        // User property name with only whitespace should be invalid
        let result = FirebaseValidator.validateUserPropertyName("   ")
        
        XCTAssertFalse(result.isValid, "Whitespace-only user property name should be invalid")
        XCTAssertEqual("invalid_property", result.sanitizedValue, "Fallback name should be used")
        XCTAssertEqual("Empty user property name", result.errorMessage, "Error message should mention empty name")
    }

    func testValidateUserPropertyName_ComplexScenario_SanitizesCorrectly() {
        // Complex scenario: firebase prefix + invalid chars + too long (24 char limit)
        let complexName = "firebase_my-complex user@prop#with$special%chars_that_exceeds_limit"
        let result = FirebaseValidator.validateUserPropertyName(complexName)
        
        XCTAssertTrue(result.isValid, "Complex user property name should be sanitized")
        XCTAssertTrue(result.isSanitized(), "User property name should be marked as sanitized")
        XCTAssertEqual(complexName, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(24, result.sanitizedValue?.count, "Result should be valid length (24 chars)")
        XCTAssertTrue(result.sanitizedValue?.first?.isLetter ?? false, "Result should start with letter")
        XCTAssertTrue(result.sanitizedValue?.range(of: "^[a-zA-Z][a-zA-Z0-9_]*$", options: .regularExpression) != nil, "Result should not contain invalid chars")
        XCTAssertFalse(result.sanitizedValue?.hasPrefix("firebase_") ?? true, "Result should not contain firebase prefix")
    }

    func testValidateUserPropertyName_Exactly24Chars_ReturnsValid() {
        // User property name with exactly 24 characters should be valid
        let exactly24Chars = "valid_twenty_four_chars_"
        XCTAssertEqual(24, exactly24Chars.count, "Test string should be exactly 24 chars")
        
        let result = FirebaseValidator.validateUserPropertyName(exactly24Chars)
        
        XCTAssertTrue(result.isValid, "24-char user property name should be valid")
        XCTAssertFalse(result.isSanitized(), "24-char name should not be sanitized")
        XCTAssertEqual(exactly24Chars, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(exactly24Chars, result.sanitizedValue, "Sanitized value should be same as original")
    }

    // MARK: - User Property Value Validation Tests

    func testValidateUserPropertyValue_ValueWithin36Chars_ReturnsValid() {
        // User property value with exactly 36 characters (limit)
        let exactly36Chars = String(repeating: "a", count: 36)
        XCTAssertEqual(36, exactly36Chars.count, "Test string should be exactly 36 chars")

        let result = FirebaseValidator.validateUserPropertyValue(exactly36Chars)

        XCTAssertTrue(result.isValid, "User property value within 36 chars should be valid")
        XCTAssertFalse(result.isSanitized(), "User property value should not be sanitized")
        XCTAssertEqual(exactly36Chars, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(exactly36Chars, result.sanitizedValue, "Sanitized value should be same as original")
        XCTAssertEqual("Valid", result.errorMessage, "Error message should indicate valid")
    }

    func testValidateUserPropertyValue_ValueOver36Chars_TruncatesCorrectly() {
        // User property value with 37 characters (should be truncated to 36)
        let thirty7Chars = String(repeating: "a", count: 37)
        XCTAssertEqual(37, thirty7Chars.count, "Test string should be exactly 37 chars")

        let result = FirebaseValidator.validateUserPropertyValue(thirty7Chars)

        XCTAssertTrue(result.isValid, "User property value should be sanitized")
        XCTAssertTrue(result.isSanitized(), "User property value should be marked as sanitized")
        XCTAssertEqual(thirty7Chars, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(36, result.sanitizedValue?.count, "Value should be truncated to 36 chars")
        XCTAssertEqual(String(thirty7Chars.prefix(36)), result.sanitizedValue, "Truncated value should match expected")
        XCTAssertEqual("User property value truncated to 36 characters", result.errorMessage, "Error message should indicate truncation")
    }

    func testValidateUserPropertyValue_NullValue_ReturnsValid() {
        // Null user property value should be handled gracefully
        let result = FirebaseValidator.validateUserPropertyValue(nil)

        XCTAssertTrue(result.isValid, "Null user property value should be valid")
        XCTAssertFalse(result.isSanitized(), "Null value should not be marked as sanitized")
        XCTAssertNil(result.originalValue, "Original value should be nil")
        XCTAssertNil(result.sanitizedValue, "Sanitized value should be nil")
        XCTAssertEqual("Valid", result.errorMessage, "Error message should indicate valid")
    }

    func testValidateUserPropertyValue_EmptyString_ReturnsValid() {
        // Empty user property value should be valid
        let result = FirebaseValidator.validateUserPropertyValue("")

        XCTAssertTrue(result.isValid, "Empty user property value should be valid")
        XCTAssertFalse(result.isSanitized(), "Empty value should not be marked as sanitized")
        XCTAssertEqual("", result.originalValue, "Original value should be empty")
        XCTAssertEqual("", result.sanitizedValue, "Sanitized value should be empty")
        XCTAssertEqual("Valid", result.errorMessage, "Error message should indicate valid")
    }

    func testValidateUserPropertyValue_ShortValue_ReturnsValid() {
        // Short user property value should be valid
        let shortValue = "short"
        let result = FirebaseValidator.validateUserPropertyValue(shortValue)

        XCTAssertTrue(result.isValid, "Short user property value should be valid")
        XCTAssertFalse(result.isSanitized(), "Short value should not be marked as sanitized")
        XCTAssertEqual(shortValue, result.originalValue, "Original value should be preserved")
        XCTAssertEqual(shortValue, result.sanitizedValue, "Sanitized value should be same as original")
        XCTAssertEqual("Valid", result.errorMessage, "Error message should indicate valid")
    }
} 