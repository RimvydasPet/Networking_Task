//
//  PostsCoreData+CoreDataProperties.swift
//  Networking_Homework
//
//  Created by Rimvydas on 2024-02-29.
//
//

import Foundation
import CoreData

extension PostsCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostsCoreData> {
        return NSFetchRequest<PostsCoreData>(entityName: "PostsCoreData")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var userId: Int64
    @NSManaged public var id: Int64

}

extension PostsCoreData : Identifiable {

}
