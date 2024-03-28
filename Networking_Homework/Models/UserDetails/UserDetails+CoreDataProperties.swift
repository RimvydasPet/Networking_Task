//
//  UserDetails+CoreDataProperties.swift
//  Networking_Homework
//
//  Created by Rimvydas on 2024-03-28.
//
//

import Foundation
import CoreData

extension UserDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetails> {
        return NSFetchRequest<UserDetails>(entityName: "UserDetails")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var username: String?

}

extension UserDetails : Identifiable {

}
