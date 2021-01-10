//
//  elastic.swift
//  Boast
//
//  Created by David Keimig on 9/15/20.
//

import Foundation
import Firebase
import FirebaseFunctions

func searchUsers(match: String, completionHandler: @escaping (Data?) -> Void) {
    let functions = Functions.functions()
    let body = [
        "query": [
            "fuzzy": [
                "displayName": match
            ]
        ]
    ]
    functions.httpsCallable("searchUsers").call(body) { (result, error) in
        if let error = error as NSError? {
            if error.domain == FunctionsErrorDomain {
                let code = FunctionsErrorCode(rawValue: error.code)
                let message = error.localizedDescription
                let details = error.userInfo[FunctionsErrorDetailsKey]
                print(code as Any, message as Any, details as Any)
            }
        }
        do {
            if result?.data != nil {
                let jsonData = try JSONSerialization.data(withJSONObject: (result?.data)!, options: [])
                completionHandler(jsonData)
            }
        } catch {
            print("Error")
            completionHandler(nil)
        }
    }
}
