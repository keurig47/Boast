//
//  activity.swift
//  Boast
//
//  Created by David Keimig on 9/22/20.
//

import Foundation
import FirebaseFirestore

struct ActivityData: Identifiable {
    var id: String
    var fromUid: String
    var body: String
    var title: String?
    var type: String
    var timestamp: Timestamp
}
