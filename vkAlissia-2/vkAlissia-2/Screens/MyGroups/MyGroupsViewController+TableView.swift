//
//  MyGroupsViewController+TableView.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 29.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource

extension MyGroupsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredGroups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        MyGroupCell.publicCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MyGroupCell.self), for: indexPath) as? MyGroupCell else { fatalError() }
        guard  let group = filteredGroups?[indexPath.row] else { fatalError() }
        
        cell.groupModel = group
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //myGroups.remove(at: indexPath.row)
            guard let group = filteredGroups?[indexPath.item] else { return }
            try? publicRealmManager?.delete(object: group)
            
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDelegate

extension MyGroupsViewController: UITableViewDelegate {
    
}

// MARK: - AllGroupsViewControllerDelegate

extension MyGroupsViewController: AllGroupsViewControllerDelegate {
    func addFavoriteGroup(_ group: GroupData) {
        //myGroups.append(group)
        //tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension MyGroupsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        publicTableView.reloadData()
    }
}

