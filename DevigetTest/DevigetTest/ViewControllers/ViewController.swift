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
    private let refreshControl = UIRefreshControl()
    private let pageLimit = 10
    @IBOutlet weak var tableView: UITableView!
    
//    Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RedditPresenter()
        presenter?.delegate = self
        // Configure Refresh Control
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshEntries(_:)), for: .valueChanged)
        
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
            presenter?.getEntries(limit: pageLimit, before: nil, after: nil)
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
    
    @objc private func refreshEntries(_ sender: Any) {
        tapDismissAll(sender)
        presenter?.getEntries(limit: pageLimit, before: nil, after: nil)
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
        self.refreshControl.endRefreshing()
    }
    
    func handleError(error: Error) {
        print(error)
    }
    
    
}
extension ViewController: RedditCellDelegate {
    func dismiss(entry: Reddit) {

        if let index = entryList!.firstIndex(of: entry) {
            print("dismiss index: \(index)")
            entryList?.remove(at: index)
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    
}
