//
//  MyGroupsViewController.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit
import RealmSwift
import PromiseKit

class MyGroupsViewController: BaseViewController {
    
    // UI
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.refreshControl = refreshControl
            tableView.register(UINib(nibName: String(describing: MyGroupCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: MyGroupCell.self))
        }
    }
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading data...", attributes: [.font: UIFont.refreshControlFont])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    var publicTableView: UITableView {
        tableView
    }
    
    // Some properties
    private var groups: Results<GroupData>? {
        let groups: Results<GroupData>? = realmManager?.getObjects()
        return groups?.sorted(byKeyPath: "groupName", ascending: true)
    }
    var filteredGroups: Results<GroupData>? {
        guard !searchText.isEmpty else { return groups }
        return groups?.filter("groupName CONTAINS[cd] %@", searchText)
    }
    private var searchText: String {
        searchBar.text ?? ""
    }
    
    private let networkManager = NetworkManager.shared
    private let realmManager = RealmManager.shared
    var publicRealmManager: RealmManager? {
        realmManager
    }
    // Promise use version
    private let networkManagerPromise = NetworkManagerPromise.shared
    
    private var filteredGroupsNotificationToken: NotificationToken?
    private var firstGroupNotificationToken: NotificationToken?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNotifications()
        
        if let groups = groups, groups.isEmpty {
            //loadData()
            
            // Promise use version
            loadDataPromise()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        searchBar.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        filteredGroupsNotificationToken?.invalidate()
        firstGroupNotificationToken?.invalidate()
    }
    
    // MARK: - Major methods
    
    private func createNotifications() {
        filteredGroupsNotificationToken = filteredGroups?.observe { [weak self] change in
            switch change {
            case .initial:
                //self?.realmManager?.refresh()
                #if DEBUG
                print("Initialized")
                #endif
                
            case let .update(results, deletions: deletions, insertions: insertions, modifications: modifications):
                #if DEBUG
                print("""
                    New count: \(results.count)
                    Deletions: \(deletions)
                    Insertions: \(insertions)
                    Modifications: \(modifications)
                    """)
                #endif
                
                self?.tableView.beginUpdates()
                
                self?.tableView.deleteRows(at: deletions.map { IndexPath(item: $0, section: 0) }, with: .automatic)
                self?.tableView.insertRows(at: insertions.map { IndexPath(item: $0, section: 0) }, with: .automatic)
                self?.tableView.reloadRows(at: modifications.map { IndexPath(item: $0, section: 0) }, with: .automatic)
                
                self?.tableView.endUpdates()
                
            case let .error(error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        
        firstGroupNotificationToken = filteredGroups?.first?.observe { [weak self] change in
            switch change {
            case let .change(object, properties):
                #if DEBUG
                let whatChanged = properties.reduce("") { res, new in
                    "\(res)\n\(new.name) -> \(new.newValue ?? "nil")"
                }
                let group = object as? GroupData
                print("Changed properties for user \(group?.groupName ?? "unknowned")\n\(whatChanged)")
                #endif
                
            case .deleted:
                #if DEBUG
                print("The first user was deleted")
                #endif
                
            case let .error(error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    
    // Operation use version
    //    private func loadData(completion: (() -> Void)? = nil) {
    //        let queue = OperationQueue()
    //
    //        let getDataOperation = GetDataOperation()
    //        queue.addOperation(getDataOperation)
    //        completion?()
    //    }
    
    // Promise use version
    private func loadDataPromise(comletion: (() -> Void)? = nil) {
        //let waiteAtLeast = after(seconds: 3)
        
        firstly {
            networkManagerPromise.networkRequest(for: .groupsGet)
        }
        .recover { Error in
            self.networkManagerPromise.networkRequest(for: .groupsGet)
        }
        .get(on: .main) { [weak self] groupItems in
            guard let self = self else { return }
            
            let groups: [GroupData] = groupItems.map {GroupData(groupItem: $0 as! GroupItem)}
            try? self.realmManager?.add(objects: groups)
        }
        .catch { error in
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
        .finally(on: .main) {
            comletion?()
        }
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            self?.networkManager.loadGroups() { [weak self] result in
                
                switch result {
                case let .success(groupItems):
                    let groups: [GroupData] = groupItems.map {GroupData(groupItem: $0)}
                    DispatchQueue.main.async { [weak self] in
                        try? self?.realmManager?.add(objects: groups)
                        completion?()
                    }
                case let .failure(error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addGroupBarButtonItem(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: String(describing: AllGroupsViewController.self)) as AllGroupsViewController
        
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func hideKeyboard(){
        searchBar.endEditing(true)
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        //        try? realmManager?.deleteAll()
        
        //        self.loadData { [weak self] in
        //            self?.refreshControl.endRefreshing()
        //        }
        
        // Promise use version
        self.loadDataPromise { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

/*
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 if segue.identifier == DetailViewController.storyboardIdentifier {
 if let destinationVC = segue.destination as? DetailViewController {
 destinationVC.user = sender as? User
 }
 }
 }
 */

