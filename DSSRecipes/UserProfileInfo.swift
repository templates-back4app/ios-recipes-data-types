//
//  UserProfileInfo.swift
//  DSSUserProfile
//
//  Created by David on 19/02/22.
//

import Foundation
import ParseSwift

struct PlayerInfo: ParseObject {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    var fullName: String?
    var age: Int?
    var birthDate: Date?
    var isPremium: Bool?
    
}
