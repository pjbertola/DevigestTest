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
    var presenter: RedditPresenter?
    var appDelegate: AppDelegate?
    @IBOutlet weak var tableView: UITableView!
    
//    Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RedditPresenter()
        presenter?.delegate = self
        guard let appDel =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        appDelegate = appDel
        managedContext = appDelegate?.persistentContainer.viewContext
        let entriesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Reddit")
        
        do {
            entryList = try managedContext!.fetch(entriesFetch) as? [Reddit]
        } catch {
            fatalError("Failed to fetch: \(error)")
        }
        if entryList?.isEmpty ?? true {
            presenter?.getEntries(limit: 50, before: nil, after: nil)
        }else{
            self.tableView.reloadData()
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
        
        appDelegate?.saveContext()
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
            cell.delegate = self
        }
        return tableViewCell ?? UITableViewCell()
    }
    
    
}
extension ViewController: RedditPresenterDelegate {
    func handleEntries(entries: [Reddit], before: String?, after: String?) {
        if entryList == nil {
            entryList = [Reddit]()
        }
        entryList?.append(contentsOf: entries)
        self.tableView.reloadData()
    }
    
    func handleError(error: Error) {
        print(error)
    }
    
    
}
extension ViewController: RedditCellDelegate {
    func dismiss(entry: Reddit) {
        deleteAll()
        tableView.reloadData()
    }
    
    
}
