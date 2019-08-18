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
        guard let _ = json else {
            return
        }
    }
}
