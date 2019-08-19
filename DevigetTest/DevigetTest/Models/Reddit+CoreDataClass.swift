//
//  Reddit+CoreDataClass.swift
//  DevigetTest
//
//  Created by Pablo Javier Bertola on 12/08/2019.
//  Copyright © 2019 Pablo Javier Bertola. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Reddit)
public class Reddit: NSManagedObject {
    func setUp(fromJson json: [String: Any]?) {
        guard let dto = json else {
            return
        }
        self.entryId = dto["id"] as? String
        self.desc = dto["title"] as? String
        self.urlImg = dto["thumbnail"] as? String
        
        self.comments = dto["num_comments"] as? Int64 ?? 0
        self.title = dto["subreddit"] as? String
        self.unSeen = false
        if let value = dto["created"] as? Int64 {
            self.date = NSDate(timeIntervalSince1970: TimeInterval(value))
        }
    }
}
