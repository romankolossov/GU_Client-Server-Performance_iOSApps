//
//  GroupsViewController.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

protocol AllGroupsViewControllerDelegate: class {
    func addFavoriteGroup(_ group: GroupData)
}

class AllGroupsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var groups: [GroupData] = []
    
    var sections: [Character: [GroupData]] = [:]
    var sectionTitles = [Character]()
    
    weak var delegate: AllGroupsViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        for group in groups {
            let firstLetter = group.groupName.first!
            
            if sections[firstLetter] != nil {
                sections[firstLetter]?.append(group)
            } else {
                sections[firstLetter] = [group]
            }
        }
        
        sectionTitles = Array(sections.keys)
        sectionTitles.sort()
        
        tableView.register(UINib(nibName: "GroupCell", bundle: Bundle.main), forCellReuseIdentifier: "GroupCell")
    }
}

// MARK: - UITableViewDataSource
extension AllGroupsViewController: UITableViewDataSource {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell else { fatalError() }
        guard  let group = sections[sectionTitles[indexPath.section]]? [indexPath.row] else { fatalError() }
        
        cell.groupNameLabel.text = group.groupName
        //cell.groupAvatarView.image = group.groupAvatar
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AllGroupsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  let group = sections[sectionTitles[indexPath.section]]? [indexPath.row] else { fatalError() }
        
        delegate?.addFavoriteGroup(group)
        
        navigationController?.popViewController(animated: true)
    }
}
