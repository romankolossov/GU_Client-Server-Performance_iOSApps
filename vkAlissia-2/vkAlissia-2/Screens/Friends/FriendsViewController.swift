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
    
    // MARK: - Constants & variables
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
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Reload data...",
                                                     attributes: [.font: UIFont.systemFont(ofSize: 10)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
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
            guard let friends = self.friends else { return }
            
            for friend in friends {
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
    
    // MARK: - @objc methods
    @objc private func refresh(_ sender: UIRefreshControl) {
        try? realmManager?.deleteAll()
        loadData { [weak self] in
            self?.refreshControl.endRefreshing()
        }
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
                print(error)
            }
        }
    }
}


//// MARK: - UITableViewDataSource
//extension FriendsViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sections[sectionTitles[section]]?.count ?? 0
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.count
//    }
//    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return sectionTitles.map{String($0)}
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return String(sectionTitles[section])
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendCell.self), for: indexPath) as? FriendCell else { fatalError() }
//        guard  let friend = sections[sectionTitles[indexPath.section]]? [indexPath.row] else { fatalError() }
//        
//        cell.nameLabel.text = friend.friendName
//        cell.friendAvatarView.sd_setImage(with: URL(string: friend.friendAvatarString), completed: nil)
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            guard let friend = friends?[indexPath.item] else { return }
//            try? realmManager?.delete(object: friend)
//            
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//}
//
//// MARK: - UITableViewDelegate
//extension FriendsViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let vc = storyboard?.instantiateViewController(identifier: String(describing: ParticularFriendViewController.self)) as? ParticularFriendViewController else { return }
//        guard let friend = sections[sectionTitles[indexPath.section]]? [indexPath.row] else { return }
//        
//        vc.friendName = friend.friendName
//        //vc.favoriteImages = friend.favorireImages
//        
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}
//
//extension FriendsViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        tableView.reloadData()
//    }
//}


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        if let destination = segue.destination as? ParticularFriendViewController {
//            guard let cell = sender as? FriendCell else { return }
//
//            destination.friendName = cell.nameLabel.text
//            destination.favoriteImages = cell.favoriteImages
//        }
//    }
