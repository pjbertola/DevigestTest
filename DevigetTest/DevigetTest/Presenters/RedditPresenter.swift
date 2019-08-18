//
//  RedditPresenter.swift
//  DevigetTest
//
//  Created by Pablo Javier Bertola on 18/08/2019.
//  Copyright © 2019 Pablo Javier Bertola. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class RedditPresenter  {
    
    var delegate: RedditPresenterDelegate?
    
    
    func getEntries(limit: Int?,
                    before: String?,
                    after: String?) {
        NetworkingManager.shared.getTopReddit(limit: limit, before: before, after: after, successHandler: { (jsonDic) in
            
            let dataD = jsonDic?["data"] as? [String: Any]
            let newBefore = dataD?["before"] as? String
            let newAfter = dataD?["after"]  as? String
            if let children = dataD?["children"] as? [[String: Any]] {
                guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                        return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                var redditList = [Reddit]()
                for entryDto in children {
                    let entryData = entryDto ["data"] as?  [String: Any]
                    guard let entityDesc = NSEntityDescription.entity(forEntityName: "Reddit", in: managedContext) else {
                        print("Fatal error")
                        return
                    }
                    let reddit = Reddit(entity: entityDesc, insertInto: managedContext)
                    reddit.setUp(fromJson: entryData)
                    redditList.append(reddit)
                }
                DispatchQueue.main.async {
                    self.delegate?.handleEntries(entries: redditList, before: newBefore, after: newAfter)
                }
            }
            
            
        }) { (error) in
            
        }
        
    }
}

protocol RedditPresenterDelegate {
    
    func handleEntries(entries: [Reddit], before: String?, after: String?)
    
    func handleError(error: Error)
    
}
