//
//  FriendsViewController.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsViewController: UIViewController {
    
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
    private var friends: Results<FriendData>? {
        let friends: Results<FriendData>? = realmManager?.getObjects()
        return friends?.sorted(byKeyPath: "friendName", ascending: true)
    }
    var filteredFriends: Results<FriendData>? {
        guard !searchText.isEmpty else { return friends }
        return friends?.filter("friendName CONTAINS[cd] %@", searchText)
    }
    private var searchText: String {
        searchBar.text ?? ""
    }
    private let networkManager = NetworkManager.shared
    private let realmManager = RealmManager.shared
    var publicRealmManager: RealmManager? {
        realmManager
    }
    var sections: [Character: [FriendData]] = [:]
    var sectionTitles = [Character]()
    
    private var filteredFriendsNotificationToken: NotificationToken?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNotification()
        
        if let friends = friends, friends.isEmpty {
            loadData()
        }
        
        tableView.register(UINib(nibName: String(describing: FriendCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: FriendCell.self))
    }
    
    deinit {
        filteredFriendsNotificationToken?.invalidate()
    }
    
    // MARK: - Major methods
    
    private func createNotification() {
        filteredFriendsNotificationToken = filteredFriends?.observe { [weak self] change in
            switch change {
            case .initial:
                self?.tableSectionsFormation()
                #if DEBUG
                print("Initialized")
                #endif
                //self?.tableView.reloadData()
                
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
    }
    
    private func tableSectionsFormation() {
        self.sections = [:]
        guard let filteredFriends = self.filteredFriends else { return }
        
        for friend in filteredFriends {
            let firstLetter = friend.friendName.first!
            
            if self.sections[firstLetter] != nil {
                self.sections[firstLetter]?.append(friend)
            } else {
                self.sections[firstLetter] = [friend]
            }
        }
        
        self.sectionTitles = Array(self.sections.keys)
        self.sectionTitles.sort()
        self.tableView.reloadData()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
//
//        })
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        networkManager.loadFriends() { [weak self] result in
            
            switch result {
            case let .success(friendItems):
                let friends: [FriendData] = friendItems.map {FriendData(friendItem: $0)}
                DispatchQueue.main.async {
                    try? self?.realmManager?.add(objects: friends)
                    //self?.tableView.reloadData()
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
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        //try? realmManager?.deleteAll()
        loadData { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}




//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        if let destination = segue.destination as? ParticularFriendViewController {
//            guard let cell = sender as? FriendCell else { return }
//
//            destination.friendName = cell.nameLabel.text
//            destination.favoriteImages = cell.favoriteImages
//        }
//    }
