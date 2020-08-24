//
//  FriendsViewController.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit
import SDWebImage

class FriendsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var friends = [FriendData]() {
        didSet {
            self.tableView.reloadData()
            #if DEBUG
            print(friends, "\n")
            #endif
        }
    }
    
    var sections: [Character: [FriendData]] = [:]
    var sectionTitles = [Character]()
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: String(describing: FriendCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: FriendCell.self))
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
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        networkManager.loadFriends() { [weak self] result in
            var myFriends = [FriendData]()
            
            switch result {
            case let .success(friendItems):
                for item in friendItems {
                    let friend = FriendData(friendItem: item)
                    myFriends.append(friend)
                }
                DispatchQueue.main.async {
                    self?.friends = myFriends
                }
            case let .failure(error):
                print(error)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.sections = [:]
            
            for friend in self.friends {
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
}


// MARK: - UITableViewDataSource
extension FriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[sectionTitles[section]]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles.map{String($0)}
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(sectionTitles[section])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendCell.self), for: indexPath) as? FriendCell else { fatalError() }
        guard  let friend = sections[sectionTitles[indexPath.section]]? [indexPath.row] else { fatalError() }
        
        cell.nameLabel.text = friend.friendName
        cell.friendAvatarView.sd_setImage(with: URL(string: friend.friendAvatarString), completed: nil)
        //cell.friendAvatarView.image = friend.friendAvatar
        //cell.favoriteImages = friend.favorireImages
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            friends.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDelegate
extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: String(describing: ParticularFriendViewController.self)) as? ParticularFriendViewController else { return }
        guard let friend = sections[sectionTitles[indexPath.section]]? [indexPath.row] else { return }
        
        vc.friendName = friend.friendName
        //vc.favoriteImages = friend.favorireImages
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
