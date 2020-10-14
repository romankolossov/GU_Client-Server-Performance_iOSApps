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
        
        cell.friendModel = friend
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //guard let friend = friends?[indexPath.item] else { return }
            guard  let friend = sections[sectionTitles[indexPath.section]]? [indexPath.row] else { fatalError() }
            
            try? publicRealmManager?.delete(object: friend)
            
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDelegate

extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let particularFriendVC = storyboard?.instantiateViewController(identifier: String(describing: ParticularFriendViewController.self)) as? ParticularFriendViewController else { return }
        guard let friend = sections[sectionTitles[indexPath.section]]? [indexPath.row] else { return }
        
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


