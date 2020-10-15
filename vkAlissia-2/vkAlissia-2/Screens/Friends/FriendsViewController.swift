//
//  FriendsViewController.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsViewController: BaseViewController {
    
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
            
            tableView.register(UINib(nibName: String(describing: FriendCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: FriendCell.self))
        }
    }
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading data...", attributes: [.font: UIFont.systemFont(ofSize: 10)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    var publicTableView: UITableView {
        tableView
    }
    
    // Some properties
    private var filteredUsers: Results<FriendData>? {
        let users: Results<FriendData>? = realmManager?.getObjects()
        guard !searchText.isEmpty else { return users }
        return users?.filter("friendName CONTAINS[cd] %@", searchText)
    }
    var sortedUsers = [[FriendData]]() {
        didSet {
            sortedIds = sortedUsers.map { $0.map { $0.id.value } }
            
            if let users: Results<FriendData> = realmManager?.getObjects() {
                self.cachedUserIds = Array(users).map { $0.id.value }
            } else {
                cachedUserIds.removeAll()
            }
        }
    }
    var sortedIds = [[Int?]]()
    var cachedUserIds = [Int?]()
    private var searchText: String {
        searchBar.text ?? ""
    }
    private let networkManager = NetworkManager.shared
    private let realmManager = RealmManager.shared
    var publicRealmManager: RealmManager? {
        realmManager
    }
    
    private var filteredUsersNotificationToken: NotificationToken?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let users = filteredUsers, users.isEmpty {
            loadData()
        }
        
        createNotification()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        searchBar.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        filteredUsersNotificationToken?.invalidate()
    }
    
    // MARK: - Major methods
    
    private func createNotification() {
        filteredUsersNotificationToken = filteredUsers?.observe { [weak self] change in
            
            guard let self = self else { return }
            
            switch change {
            case .initial:
                //self?.realmManager?.refresh()
                self.sortUsers()
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                #if DEBUG
                print("Initialized")
                #endif
                
            case let .update(results, deletions: del, insertions: ins, modifications: mod):
                #if DEBUG
                print("""
                    New count: \(results.count)
                    Deletions: \(del)
                    Insertions: \(ins)
                    Modifications: \(mod)
                    """)
                #endif
                
                let deletions = del.compactMap { self.getUserIndexPathByRealmOrder(order: $0) }
                let modifications = mod.compactMap { self.getUserIndexPathByRealmOrder(order: $0) }
                
                self.sortUsers()
                
                let insertions = ins.compactMap { self.getUserIndexPathByRealmOrder(order: $0) }
                
                guard insertions.count == 0 else {
                    self.tableView.reloadData()
                    self.tableView.layoutIfNeeded()
                    return
                }
                
                self.tableView.beginUpdates()
                
                if !modifications.isEmpty {
                    self.tableView.reloadRows(at: modifications, with: .automatic)
                }
                if !deletions.isEmpty {
                    let rowsInDeleteSections = Set(deletions.map { $0.section })
                        .compactMap { ($0, self.tableView.numberOfRows(inSection: $0)) }
                    let sectionsWithOneCell = rowsInDeleteSections.filter { section, count in count == 1 }.map { section, _ in section }
                    let sectionsWithMoreCells = rowsInDeleteSections.filter { section, count in count > 1 }.map { section, _ in section }
                    if sectionsWithOneCell.count > 0 {
                        self.tableView.deleteSections(IndexSet(sectionsWithOneCell), with: .automatic)
                    }
                    if sectionsWithMoreCells.count > 0 {
                        let indexForDeletion = deletions.filter { sectionsWithMoreCells.contains($0.section) }
                        self.tableView.deleteRows(at: indexForDeletion, with: .automatic)
                    }
                }
                //TODO....
                //                if !insertions.isEmpty {
                //                    let newSections = self.sortedUsers.enumerated()
                //                        .compactMap({ $1.contains(where: { ins.contains($0.id.value ?? -1) }) ? $0 : nil })
                //                    self.tableView.insertSections(IndexSet(newSections), with: .automatic)
                //                    self.tableView.insertRows(at: insertions, with: .automatic)
                //                }
                
                self.tableView.endUpdates()
                
                
            case let .error(error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func sortUsers() {
        sortedUsers.removeAll()
        
        guard let filteredUsers = filteredUsers else { return }
        let users: [FriendData] = Array(filteredUsers)
        var sortedUsers = [[FriendData]]()
        
        let groupedElements = Dictionary(grouping: users) { user -> String in
            return String(user.friendName.prefix(1))
        }
        let sortedKeys = groupedElements.keys.sorted()
        sortedKeys.forEach { key in
            if let values = groupedElements[key] {
                sortedUsers.append(values)
            }
        }
        
        self.sortedUsers = sortedUsers
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            self?.networkManager.loadFriends() { [weak self] result in
                
                switch result {
                case let .success(friendItems):
                    let friends: [FriendData] = friendItems.map {FriendData(friendItem: $0)}
                    DispatchQueue.main.async { [weak self] in
                        try? self?.realmManager?.add(objects: friends)
                        //self?.tableView.reloadData()
                        completion?()
                    }
                case let .failure(error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func getUserIndexPathByRealmOrder(order: Int) -> IndexPath? {
        guard order < cachedUserIds.count, let userId = cachedUserIds[order] else { return nil }
        
        guard let section = sortedIds.firstIndex(where: { $0.contains(userId) }),
            let item = sortedIds[section].firstIndex(where: { $0 == userId }) else { return nil }
        
        return IndexPath(item: item, section: section)
    }
    
    // MARK: - Actions
    
    @objc func hideKeyboard(){
        searchBar.endEditing(true)
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        //try? realmManager?.deleteAll()
        self.loadData { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}



/*
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 super.prepare(for: segue, sender: sender)
 if let destination = segue.destination as? ParticularFriendViewController {
 guard let cell = sender as? FriendCell else { return }
 
 destination.friendName = cell.nameLabel.text
 destination.favoriteImages = cell.favoriteImages
 }
 }
 
 DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
 
 })
 */
