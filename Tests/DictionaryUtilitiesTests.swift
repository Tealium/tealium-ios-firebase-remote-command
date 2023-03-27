//
//  DictionaryUtilitiesTests.swift
//  TealiumFirebaseTests
//
//  Created by Enrico Zannini on 24/03/23.
//

import XCTest
@testable import TealiumFirebase

final class DictionaryUtilitiesTests: XCTestCase {

    func testNormalizeItemsChangesValuesToArrays() {
        let dict: [String: Any] = ["param_item_key1": "value1", "param_item_key2": 2, "param_item_key3": false]
        let result = dict.normalizeParamsArrays()
        let expected: [String: Any] = ["param_item_key1": ["value1"], "param_item_key2": [2], "param_item_key3": [false]]
        XCTAssertTrue(NSDictionary(dictionary: result).isEqual(to:  expected))
    }
    
    func testNormalizeItemsFiltersOutNonItems() {
        let dict: [String: Any] = ["key1": "value1", "param_item_key2": 2, "param_item_key3": false]
        let result = dict.normalizeParamsArrays()
        let expected: [String: Any] = ["param_item_key2": [2], "param_item_key3": [false]]
        XCTAssertTrue(NSDictionary(dictionary: result).isEqual(to:  expected))
    }
    
    func testNormalizeItemsDontChangeArrays() {
        let dict: [String: Any] = ["param_item_key1": ["value1"], "param_item_key2": [2], "param_item_key3": [false]]
        let result = dict.normalizeParamsArrays()
        let expected: [String: Any] = ["param_item_key1": ["value1"], "param_item_key2": [2], "param_item_key3": [false]]
        XCTAssertTrue(NSDictionary(dictionary: result).isEqual(to:  expected))
    }
    
    func testItemsArrayToArrayOfItems() {
        let dict: [String: Any] = ["param_item_key1": ["value1a", "value1b"], "param_item_key2": [2, 22], "param_item_key3": [false, true]]
        let result = dict.itemArraysToArrayOfItems()
        let expectedArray: [[String: Any]] = [["param_item_key1": "value1a", "param_item_key2": 2, "param_item_key3": false], ["param_item_key1": "value1b", "param_item_key2": 22, "param_item_key3": true]]
        XCTAssertEqual(expectedArray.count, result.count)
        for i in 0..<expectedArray.count {
            XCTAssertTrue(NSDictionary(dictionary: result[i]).isEqual(to:  expectedArray[i]))
        }
    }
}
