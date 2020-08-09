//
//  MyGroupsViewController.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class MyGroupsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var myGroups: [GroupData] = [
        GroupData(groupName: "Test Group", groupAvatar: UIImage(named: "Acura")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "MyGroupCell", bundle: Bundle.main), forCellReuseIdentifier: "MyGroupCell")
    }
    
    @IBAction func addGroupBarButtonItem(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AllGroupsViewController") as AllGroupsViewController
        
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MyGroupsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as? MyGroupCell else { fatalError() }
        
        let group = myGroups[indexPath.row]
        
        cell.myGroupNameLabel.text = group.groupName
        cell.myGroupAvatarView.image = group.groupAvatar
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroups.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDelegate
extension MyGroupsViewController: UITableViewDelegate {
    
}

// MARK: - AllGroupsViewControllerDelegate
extension MyGroupsViewController: AllGroupsViewControllerDelegate {
    func addFavoriteGroup(_ group: GroupData) {
        myGroups.append(group)
        tableView.reloadData()
    }
}
    
    
