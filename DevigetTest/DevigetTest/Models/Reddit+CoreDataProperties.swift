//
//  Reddit+CoreDataProperties.swift
//  DevigetTest
//
//  Created by Pablo Javier Bertola on 12/08/2019.
//  Copyright © 2019 Pablo Javier Bertola. All rights reserved.
//
//

import Foundation
import CoreData


extension Reddit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reddit> {
        return NSFetchRequest<Reddit>(entityName: "Reddit")
    }

    @NSManaged public var comments: Int64
    @NSManaged public var date: NSDate?
    @NSManaged public var desc: String?
    @NSManaged public var title: String?
    @NSManaged public var unSeen: Bool
    @NSManaged public var urlImg: String?

}
