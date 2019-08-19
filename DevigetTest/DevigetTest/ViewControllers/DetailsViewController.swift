//
//  DetailsViewController.swift
//  DevigetTest
//
//  Created by Pablo Javier Bertola on 19/08/2019.
//  Copyright © 2019 Pablo Javier Bertola. All rights reserved.
//

import Foundation
import UIKit
class DetailsViewController: UIViewController {
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var detailLb: UILabel!
    var reddit: Reddit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLb.text = reddit?.title
        detailLb.text = reddit?.desc
        if let imgUrl = URL(string: reddit?.urlImg ?? "") {
            self.imgView.load(url: imgUrl)
        }
    }
}
