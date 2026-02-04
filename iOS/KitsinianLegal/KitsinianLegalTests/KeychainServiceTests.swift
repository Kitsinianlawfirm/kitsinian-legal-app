//
//  KeychainServiceTests.swift
//  KitsinianLegalTests
//
//  Unit tests for KeychainService
//

import XCTest
@testable import KitsinianLegal

final class KeychainServiceTests: XCTestCase {

    // Use a test-specific key to avoid conflicts
    private let testKey = KeychainService.Key.deviceId

    override func setUp() async throws {
        try await super.setUp()
        // Clean up before each test
        try? KeychainService.shared.delete(forKey: testKey)
    }

    override func tearDown() async throws {
        // Clean up after each test
        try? KeychainService.shared.delete(forKey: testKey)
        try await super.tearDown()
    }

    // MARK: - String Storage Tests

    func testSetAndGetString() throws {
        let testValue = "test-token-12345"

        try KeychainService.shared.set(testValue, forKey: testKey)
        let retrieved = try KeychainService.shared.getString(forKey: testKey)

        XCTAssertEqual(retrieved, testValue)
    }

    func testGetStringOptionalReturnsNilWhenNotFound() {
        let result = KeychainService.shared.getStringOptional(forKey: .authToken)
        // Should return nil for non-existent key (authToken shouldn't exist in tests)
        // Note: This might fail if there's a real auth token stored
        XCTAssertNil(result)
    }

    func testGetStringThrowsWhenNotFound() {
        XCTAssertThrowsError(try KeychainService.shared.getString(forKey: .authToken)) { error in
            XCTAssertTrue(error is KeychainError)
            if let keychainError = error as? KeychainError {
                XCTAssertEqual(keychainError.errorDescription, "Item not found in Keychain")
            }
        }
    }

    func testUpdateExistingValue() throws {
        let originalValue = "original-value"
        let updatedValue = "updated-value"

        try KeychainService.shared.set(originalValue, forKey: testKey)
        try KeychainService.shared.set(updatedValue, forKey: testKey)

        let retrieved = try KeychainService.shared.getString(forKey: testKey)
        XCTAssertEqual(retrieved, updatedValue)
    }

    // MARK: - Delete Tests

    func testDeleteExistingItem() throws {
        try KeychainService.shared.set("value-to-delete", forKey: testKey)
        XCTAssertTrue(KeychainService.shared.exists(forKey: testKey))

        try KeychainService.shared.delete(forKey: testKey)
        XCTAssertFalse(KeychainService.shared.exists(forKey: testKey))
    }

    func testDeleteNonExistentItemDoesNotThrow() {
        XCTAssertNoThrow(try KeychainService.shared.delete(forKey: .authToken))
    }

    // MARK: - Exists Tests

    func testExistsReturnsTrueForStoredItem() throws {
        try KeychainService.shared.set("test", forKey: testKey)
        XCTAssertTrue(KeychainService.shared.exists(forKey: testKey))
    }

    func testExistsReturnsFalseForMissingItem() {
        XCTAssertFalse(KeychainService.shared.exists(forKey: .apiKey))
    }

    // MARK: - Codable Storage Tests

    func testSetAndGetCodable() throws {
        struct TestStruct: Codable, Equatable {
            let id: Int
            let name: String
        }

        let testObject = TestStruct(id: 123, name: "Test User")

        try KeychainService.shared.set(testObject, forKey: testKey)
        let retrieved: TestStruct = try KeychainService.shared.get(forKey: testKey)

        XCTAssertEqual(retrieved, testObject)
    }

    // MARK: - Authentication Helpers Tests

    func testIsAuthenticatedReturnsFalseWhenNoToken() {
        // Clear any existing auth token
        try? KeychainService.shared.delete(forKey: .authToken)
        XCTAssertFalse(KeychainService.shared.isAuthenticated)
    }

    func testIsAuthenticatedReturnsTrueWhenTokenExists() throws {
        try KeychainService.shared.set("fake-auth-token", forKey: .authToken)
        XCTAssertTrue(KeychainService.shared.isAuthenticated)

        // Clean up
        try KeychainService.shared.delete(forKey: .authToken)
    }

    func testClearAuthenticationRemovesTokens() throws {
        try KeychainService.shared.set("auth-token", forKey: .authToken)
        try KeychainService.shared.set("refresh-token", forKey: .refreshToken)

        KeychainService.shared.clearAuthentication()

        XCTAssertFalse(KeychainService.shared.exists(forKey: .authToken))
        XCTAssertFalse(KeychainService.shared.exists(forKey: .refreshToken))
    }

    func testStoreAuthTokens() throws {
        try KeychainService.shared.storeAuthTokens(accessToken: "access-123", refreshToken: "refresh-456")

        XCTAssertEqual(try KeychainService.shared.getString(forKey: .authToken), "access-123")
        XCTAssertEqual(try KeychainService.shared.getString(forKey: .refreshToken), "refresh-456")

        // Clean up
        KeychainService.shared.clearAuthentication()
    }

    // MARK: - Device ID Tests

    func testGetOrCreateDeviceIdCreatesNewId() {
        try? KeychainService.shared.delete(forKey: .deviceId)

        let deviceId = KeychainService.shared.getOrCreateDeviceId()

        XCTAssertFalse(deviceId.isEmpty)
        // Verify it's a valid UUID format
        XCTAssertNotNil(UUID(uuidString: deviceId))
    }

    func testGetOrCreateDeviceIdReturnsExistingId() {
        let firstId = KeychainService.shared.getOrCreateDeviceId()
        let secondId = KeychainService.shared.getOrCreateDeviceId()

        XCTAssertEqual(firstId, secondId)
    }

    // MARK: - Unicode Support Tests

    func testUnicodeStringStorage() throws {
        let unicodeValue = "Test with émojis 🎉 and ünïcödé"

        try KeychainService.shared.set(unicodeValue, forKey: testKey)
        let retrieved = try KeychainService.shared.getString(forKey: testKey)

        XCTAssertEqual(retrieved, unicodeValue)
    }

    // MARK: - Empty String Tests

    func testEmptyStringStorage() throws {
        try KeychainService.shared.set("", forKey: testKey)
        let retrieved = try KeychainService.shared.getString(forKey: testKey)

        XCTAssertEqual(retrieved, "")
    }

    // MARK: - Long Value Tests

    func testLongStringStorage() throws {
        let longValue = String(repeating: "a", count: 10000)

        try KeychainService.shared.set(longValue, forKey: testKey)
        let retrieved = try KeychainService.shared.getString(forKey: testKey)

        XCTAssertEqual(retrieved, longValue)
    }
}
