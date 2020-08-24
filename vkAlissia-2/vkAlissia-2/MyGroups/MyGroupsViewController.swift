//
//  MyGroupsViewController.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit
import SDWebImage

class MyGroupsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var myGroups: [GroupData] = []
    let networkManager = NetworkManager()
    
//    var myGroups: [GroupData] = [
//        GroupData(groupName: "Test Group", groupAvatar: UIImage(named: "Acura")!)
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "MyGroupCell", bundle: Bundle.main), forCellReuseIdentifier: "MyGroupCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        networkManager.loadGroups() { [weak self] result in
            var groups: [GroupData] = []
            switch result {
            case let .success(groupItems):
                for item in groupItems {
                    let group = GroupData(groupItem: item)
                    groups.append(group)
                    #if DEBUG
                    print(group.groupName)
                    print(group.groupAvatarString, "\n")
                    #endif
                }
            case let .failure(error):
                print(error)
            }
            self?.myGroups = groups
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
        cell.myGroupAvatarView.sd_setImage(with: URL(string: group.groupAvatarString), completed: nil)
        //cell.myGroupAvatarView.image = group.groupAvatar
        
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
    
    
