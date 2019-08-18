//
//  RedditCell.swift
//  DevigetTest
//
//  Created by Pablo Javier Bertola on 11/08/2019.
//  Copyright © 2019 Pablo Javier Bertola. All rights reserved.
//

import Foundation
import UIKit

class RedditCell: UITableViewCell{
    var reddit: Reddit?
    var delegate: RedditCellDelegate?
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var descriptionLb: UILabel!
    @IBOutlet weak var commentsLb: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    
    func setUp(with entry: Reddit)  {
        reddit = entry
        self.timeLb.text = entry.title
        self.descriptionLb.text = entry.desc
        self.commentsLb.text = NSLocalizedString("Comments: ", comment: "") + String(entry.comments)
        
        
        if let dateRangeEnd = entry.date as Date? {
            let dateRangeStart = Date()
            let components = Calendar.current.dateComponents([.weekOfYear, .month], from: dateRangeStart, to: dateRangeEnd )
            
            print("difference is \(components.hour ?? 0) hours")

            self.timeLb.text = String(components.hour ?? 0) + NSLocalizedString(" hours ago.", comment: "")
        }
        if let imgUrl = URL(string: entry.urlImg ?? "") {
            self.imgView.load(url: imgUrl)
        }
    }
    
    @IBAction func tapDismiss(_ sender: Any) {
        if let entry = reddit {
            delegate?.dismiss(entry: entry)
        }
    }
}

protocol RedditCellDelegate {
    func dismiss(entry: Reddit)
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
