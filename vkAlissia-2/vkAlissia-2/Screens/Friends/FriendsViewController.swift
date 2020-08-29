//
//  FriendsViewController.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class FriendsViewController: UIViewController {
    
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
    
    private var friends: Results<FriendData>? {
        let friends: Results<FriendData>? = realmManager?.getObjects()
        return friends?.sorted(byKeyPath: "id", ascending: true)
    }
    var filteredFriends: Results<FriendData>? {
        guard !searchText.isEmpty else { return friends }
        return friends?.filter("name CONTAINS[cd] %@", searchText)
    }
    private var searchText: String {
        searchBar.text ?? ""
    }
    var sections: [Character: [FriendData]] = [:]
    var sectionTitles = [Character]()
    
    private let networkManager = NetworkManager()
    private let realmManager = RealmManager.shared
    var publicRealmManager: RealmManager? {
        realmManager
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let friends = friends, friends.isEmpty {
            loadData()
        }
        
        tableView.register(UINib(nibName: String(describing: FriendCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: FriendCell.self))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
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
        })
    }
    
    // MARK: - Major methods
    
    private func loadData(completion: (() -> Void)? = nil) {
        networkManager.loadFriends() { [weak self] result in
            var friends = [FriendData]()
            
            switch result {
            case let .success(friendItems):
                for item in friendItems {
                    let friend = FriendData(friendItem: item)
                    friends.append(friend)
                }
                DispatchQueue.main.async {
                    try? self?.realmManager?.add(objects: friends)
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
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        try? realmManager?.deleteAll()
        loadData { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UISearchBarDelegate

extension FriendsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
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
