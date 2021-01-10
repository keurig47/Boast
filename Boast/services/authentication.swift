//
//  authentication.swift
//  Boast
//
//  Created by David Keimig on 9/16/20.
//

import Foundation
import Firebase
import FirebaseFunctions

func validateEmail(email: String, completionHandler: @escaping (Bool, String?, [OAuthProviderData]?) -> Void) {
    let functions = Functions.functions()
    let body = [
        "email": email
    ]
    functions.httpsCallable("validateEmail").call(body) { (result, error) in
        if (error != nil) {
            completionHandler(false, "Error completing request", [])
        }
        let data = result?.data
        if data != nil {
            let json = data as! [String: Any]
            let providerData = json["providers"] as? [[String: String]]
            if providerData == nil {
                completionHandler(
                    json["valid"] as! Bool,
                    json["message"] as? String,
                    []
                )
            } else {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: providerData!, options: [])
                    let decoder = JSONDecoder()
                    let results = try decoder.decode([OAuthProviderData].self, from: jsonData)
                    completionHandler(
                        json["valid"] as! Bool,
                        json["message"] as? String,
                        results
                    )
                } catch {
                    completionHandler(
                        json["valid"] as! Bool,
                        json["message"] as? String,
                        []
                    )
                }
            }
        }
    }
}

func validateUsername(username: String, completionHandler: @escaping (Bool, String?) -> Void) {
    let functions = Functions.functions()
    let body = [
        "username": username
    ]
    functions.httpsCallable("validateUsername").call(body) { (result, error) in
        if (error != nil) {
            completionHandler(false, "Error completing request")
        }
        let data = result?.data
        if data != nil {
            let json = data as! [String: Any]
            completionHandler(json["valid"] as! Bool, json["message"] as? String)
        }
    }
}
