//
//  ViewController.swift
//  DevigetTest
//
//  Created by Pablo Javier Bertola on 11/08/2019.
//  Copyright © 2019 Pablo Javier Bertola. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
//    Properties
    var managedContext: NSManagedObjectContext?
    var entryList: [Reddit]?
    @IBOutlet weak var tableView: UITableView!
    
//    Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        managedContext = appDelegate.persistentContainer.viewContext
        let entriesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Reddit")
        
        do {
            entryList = try managedContext!.fetch(entriesFetch) as? [Reddit]
            print("entry list")
        } catch {
            fatalError("Failed to fetch: \(error)")
        }
        if entryList?.isEmpty ?? false {
            //reloadData
        }else{
            //call service
        }
    }

    @IBAction func tapDismissAll(_ sender: Any) {
        deleteAll()
        self.entryList = nil
        self.tableView.reloadData()
    }
    
    func deleteAll()
    {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Reddit")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try managedContext!.execute(request)
        } catch {
            fatalError("Failed to fetch: \(error)")
        }
        

    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "RedditCell", for: indexPath) as? RedditCell
        
        if let cell =  tableViewCell {
            if let reddit = entryList?[indexPath.row] {
                cell.setUp(with: reddit)
            }
        }
        return tableViewCell ?? UITableViewCell()
    }
    
    
}
