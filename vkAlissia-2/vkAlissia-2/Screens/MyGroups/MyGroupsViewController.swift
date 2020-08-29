//
//  MyGroupsViewController.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class MyGroupsViewController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.refreshControl = refreshControl
        }
    }
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Reload data...",
                                                     attributes: [.font: UIFont.systemFont(ofSize: 10)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Some constants & variables
    
    private var myGroups: Results<GroupData>? {
        let myGroups: Results<GroupData>? = realmManager?.getObjects()
        return myGroups?.sorted(byKeyPath: "id", ascending: true)
    }
    var filteredGroups: Results<GroupData>? {
        guard !searchText.isEmpty else { return myGroups }
        return myGroups?.filter("name CONTAINS[cd] %@", searchText)
    }
    private var searchText: String {
        searchBar.text ?? ""
    }
    
    private let networkManager = NetworkManager()
    private let realmManager = RealmManager.shared
    var publicRealmManager: RealmManager? {
        realmManager
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let myGroups = myGroups, myGroups.isEmpty {
            loadData()
        }
        
        tableView.register(UINib(nibName: String(describing: MyGroupCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: MyGroupCell.self))
    }
    
    // MARK: - Major methods
    
    private func loadData(completion: (() -> Void)? = nil) {
        networkManager.loadGroups() { [weak self] result in
            var groups = [GroupData]()
            
            switch result {
            case let .success(groupItems):
                for item in groupItems {
                    let friend = GroupData(groupItem: item)
                    groups.append(friend)
                }
                DispatchQueue.main.async {
                    try? self?.realmManager?.add(objects: groups)
                    self?.tableView.reloadData()
                    completion?()
                }
            case let .failure(error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(title: String? = nil,
                           message: String? = nil,
                           handler: ((UIAlertAction) -> ())? = nil,
                           completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: completion)
    }
    
    // MARK: - Actions
    
    @IBAction func addGroupBarButtonItem(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: String(describing: AllGroupsViewController.self)) as AllGroupsViewController
        
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        try? realmManager?.deleteAll()
        loadData { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

// MARK: - AllGroupsViewControllerDelegate

extension MyGroupsViewController: AllGroupsViewControllerDelegate {
    func addFavoriteGroup(_ group: GroupData) {
        //myGroups.append(group)
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension MyGroupsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
}
    
    
