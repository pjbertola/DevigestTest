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
    private var isFetchingMore = false
    private var after: String?
    @IBOutlet weak var tableView: UITableView!
    
    
//    Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RedditPresenter()
        presenter?.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
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
        entryList = nil
        after = nil
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        // "* 2" is there to load before the end.
        if offSetY > contentHeight - scrollView.frame.height * 2 {
            if !isFetchingMore {
                fetchingMore()
            }
        }
    }
    func fetchingMore() {
        isFetchingMore = true
        presenter?.getEntries(limit: pageLimit, before: nil, after: after)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsSegue" {
            if let nav = segue.destination as? UINavigationController {
                if let vc = nav.viewControllers.first as? DetailsViewController {
                    if let reddit = sender as? Reddit {
                        vc.reddit = reddit
                    }
                }
            }
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
            cell.delegate = self
        }
        return tableViewCell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let reddit = entryList?[indexPath.row] {
            if reddit.newEntry {
                reddit.newEntry = false
                appDelegate?.saveContext()
            }
            performSegue(withIdentifier: "DetailsSegue", sender: reddit)
        }
    }
    
}
extension ViewController: RedditPresenterDelegate {
    func handleEntries(entries: [Reddit], before: String?, after: String?) {
        if entryList == nil {
            entryList = [Reddit]()
        }
        let initialCount = entryList?.count ?? 0
        entryList?.append(contentsOf: entries)
        self.after = after
        isFetchingMore = false
        var indexList = [IndexPath]()
        for i in initialCount...(entryList!.count - 1){
            indexList.append(IndexPath(row: i, section: 0))
        }
        self.refreshControl.endRefreshing()
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexList, with: .automatic)
        self.tableView.endUpdates()
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
