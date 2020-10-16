//
//  FriendsViewController+TableView.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 28.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource

extension FriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sortedUsers.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        String(sortedUsers[section].first?.friendName.first ?? Character(""))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedUsers[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendCell.self), for: indexPath) as? FriendCell else { fatalError() }
        
        let friend = sortedUsers[indexPath.section][indexPath.item]
        cell.friendModel = friend
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let friend = sortedUsers[indexPath.section][indexPath.item]
            try? publicRealmManager?.delete(object: friend)
        }
    }
}

// MARK: - UITableViewDelegate

extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let particularFriendVC = storyboard?.instantiateViewController(identifier: String(describing: ParticularFriendViewController.self)) as? ParticularFriendViewController else { return }
        let friend = sortedUsers[indexPath.section][indexPath.item]
        
        particularFriendVC.friendName = friend.friendName
        
        Session.shared.friendId = friend.id.value ?? -1
        
        navigationController?.pushViewController(particularFriendVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension FriendsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        publicTableView.reloadData()
    }
}


