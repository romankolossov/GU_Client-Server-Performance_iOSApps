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
        return filteredGroups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MyGroupCell.self), for: indexPath) as? MyGroupCell else { fatalError() }
        guard  let group = filteredGroups?[indexPath.row] else { fatalError() }
        
        cell.myGroupNameLabel.text = group.groupName
        cell.myGroupAvatarView.sd_setImage(with: URL(string: group.groupAvatarString), completed: nil)
        
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

