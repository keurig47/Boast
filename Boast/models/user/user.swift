//
//  user.swift
//  Boast
//
//  Created by David Keimig on 9/21/20.
//

import Foundation

struct UserData: Identifiable, Codable {
    var id: String
    var disabled: Bool?
    var displayName: String?
    var email: String?
    var emailVerified: Bool?
    
    enum CodingKeys: String, CodingKey {
        case displayName = "displayName"
        case disabled = "disabled"
        case email = "email"
        case emailVerified = "emailVerified"
        case id = "uid"
    }
}

struct ElasticUser: Identifiable, Codable {
    var id: String
    var displayName: String?
    var email: String
    var photoURL: String?
    
    enum CodingKeys: String, CodingKey {
        case displayName = "displayName"
        case email = "email"
        case photoURL = "photoURL"
        case id = "uid"
    }
}

struct ElasticResult: Identifiable, Codable {
    var id: String
    var _index: String
    var _score: Double
    var _source: ElasticUser
    var _type: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case _index = "_index"
        case _score = "_score"
        case _source = "_source"
        case _type = "_type"
    }
}

