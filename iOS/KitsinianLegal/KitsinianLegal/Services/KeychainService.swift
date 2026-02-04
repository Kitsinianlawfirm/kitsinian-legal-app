//
//  KeychainService.swift
//  ClaimIt
//
//  Secure storage service using iOS Keychain for sensitive data
//

import Foundation
import Security

// MARK: - Keychain Error
enum KeychainError: LocalizedError {
    case itemNotFound
    case duplicateItem
    case unexpectedStatus(OSStatus)
    case encodingFailed
    case decodingFailed
    case accessDenied

    var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "Item not found in Keychain"
        case .duplicateItem:
            return "Item already exists in Keychain"
        case .unexpectedStatus(let status):
            return "Keychain error: \(status)"
        case .encodingFailed:
            return "Failed to encode data for Keychain"
        case .decodingFailed:
            return "Failed to decode data from Keychain"
        case .accessDenied:
            return "Access to Keychain denied"
        }
    }
}

// MARK: - Keychain Service
final class KeychainService {

    // MARK: - Singleton
    static let shared = KeychainService()

    // MARK: - Configuration
    private let serviceName: String
    private let accessGroup: String?

    // MARK: - Keys
    enum Key: String {
        case authToken = "com.claimit.auth.token"
        case refreshToken = "com.claimit.auth.refreshToken"
        case userId = "com.claimit.user.id"
        case userEmail = "com.claimit.user.email"
        case deviceId = "com.claimit.device.id"
        case apiKey = "com.claimit.api.key"
    }

    // MARK: - Initialization
    private init(
        serviceName: String = Bundle.main.bundleIdentifier ?? "com.kitsinianlawfirm.claimit",
        accessGroup: String? = nil
    ) {
        self.serviceName = serviceName
        self.accessGroup = accessGroup
    }

    // MARK: - String Storage

    /// Save a string value to Keychain
    func set(_ value: String, forKey key: Key) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.encodingFailed
        }
        try setData(data, forKey: key.rawValue)
    }

    /// Retrieve a string value from Keychain
    func getString(forKey key: Key) throws -> String {
        let data = try getData(forKey: key.rawValue)
        guard let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.decodingFailed
        }
        return string
    }

    /// Get string or nil if not found
    func getStringOptional(forKey key: Key) -> String? {
        try? getString(forKey: key)
    }

    // MARK: - Codable Storage

    /// Save a Codable object to Keychain
    func set<T: Encodable>(_ value: T, forKey key: Key) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        try setData(data, forKey: key.rawValue)
    }

    /// Retrieve a Codable object from Keychain
    func get<T: Decodable>(forKey key: Key) throws -> T {
        let data = try getData(forKey: key.rawValue)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

    /// Get Codable object or nil if not found
    func getOptional<T: Decodable>(forKey key: Key) -> T? {
        try? get(forKey: key)
    }

    // MARK: - Delete

    /// Delete a single item from Keychain
    func delete(forKey key: Key) throws {
        try deleteData(forKey: key.rawValue)
    }

    /// Delete all items for this service
    func deleteAll() throws {
        let query = baseQuery()

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    // MARK: - Check Existence

    func exists(forKey key: Key) -> Bool {
        var query = baseQuery()
        query[kSecAttrAccount as String] = key.rawValue
        query[kSecReturnData as String] = false

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    // MARK: - Private Methods

    private func baseQuery() -> [String: Any] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName
        ]

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }

        return query
    }

    private func setData(_ data: Data, forKey key: String) throws {
        // Try to update first (more common operation)
        var query = baseQuery()
        query[kSecAttrAccount as String] = key

        let updateAttributes: [String: Any] = [
            kSecValueData as String: data
        ]

        var status = SecItemUpdate(query as CFDictionary, updateAttributes as CFDictionary)

        if status == errSecItemNotFound {
            // Item doesn't exist, add it
            query[kSecValueData as String] = data
            query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly

            status = SecItemAdd(query as CFDictionary, nil)
        }

        guard status == errSecSuccess else {
            if status == errSecDuplicateItem {
                throw KeychainError.duplicateItem
            } else if status == errSecAuthFailed {
                throw KeychainError.accessDenied
            }
            throw KeychainError.unexpectedStatus(status)
        }
    }

    private func getData(forKey key: String) throws -> Data {
        var query = baseQuery()
        query[kSecAttrAccount as String] = key
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeychainError.itemNotFound
            } else if status == errSecAuthFailed {
                throw KeychainError.accessDenied
            }
            throw KeychainError.unexpectedStatus(status)
        }

        guard let data = result as? Data else {
            throw KeychainError.decodingFailed
        }

        return data
    }

    private func deleteData(forKey key: String) throws {
        var query = baseQuery()
        query[kSecAttrAccount as String] = key

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}

// MARK: - Convenience Extensions
extension KeychainService {

    /// Check if user is authenticated (has auth token)
    var isAuthenticated: Bool {
        exists(forKey: .authToken)
    }

    /// Clear all authentication data
    func clearAuthentication() {
        try? delete(forKey: .authToken)
        try? delete(forKey: .refreshToken)
        try? delete(forKey: .userId)
        try? delete(forKey: .userEmail)
    }

    /// Store authentication tokens
    func storeAuthTokens(accessToken: String, refreshToken: String? = nil) throws {
        try set(accessToken, forKey: .authToken)
        if let refreshToken = refreshToken {
            try set(refreshToken, forKey: .refreshToken)
        }
    }

    /// Get or generate a unique device ID
    func getOrCreateDeviceId() -> String {
        if let existingId = getStringOptional(forKey: .deviceId) {
            return existingId
        }

        let newId = UUID().uuidString
        try? set(newId, forKey: .deviceId)
        return newId
    }
}

// MARK: - Debug Helpers
#if DEBUG
extension KeychainService {
    /// Print all stored keys (for debugging only)
    func debugPrintStoredKeys() {
        print("=== Keychain Debug ===")
        for key in [Key.authToken, .refreshToken, .userId, .userEmail, .deviceId, .apiKey] {
            let exists = exists(forKey: key)
            print("  \(key.rawValue): \(exists ? "stored" : "empty")")
        }
        print("======================")
    }
}
#endif
