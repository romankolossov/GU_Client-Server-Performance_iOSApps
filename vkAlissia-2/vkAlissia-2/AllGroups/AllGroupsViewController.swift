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
//    var groups: [GroupData] = [
//        GroupData(groupName: "Acura", groupAvatar: UIImage(named: "Acura")!),
//        GroupData(groupName: "Alfa_Romeo", groupAvatar: UIImage(named: "Alfa_Romeo")!),
//        GroupData(groupName: "Aston_Martin", groupAvatar: UIImage(named: "Aston_Martin")!),
//        GroupData(groupName: "Audi", groupAvatar: UIImage(named: "Audi")!),
//        GroupData(groupName: "Bentley", groupAvatar: UIImage(named: "Bentley")!),
//        GroupData(groupName: "BMW", groupAvatar: UIImage(named: "BMW")!),
//        GroupData(groupName: "Citroen", groupAvatar: UIImage(named: "Citroen")!),
//        GroupData(groupName: "Ferrari", groupAvatar: UIImage(named: "Ferrari")!),
//        GroupData(groupName: "Jaguar", groupAvatar: UIImage(named: "Jaguar")!),
//        GroupData(groupName: "Land_Rover", groupAvatar: UIImage(named: "Land_Rover")!),
//        GroupData(groupName: "Mercedes-Benz", groupAvatar: UIImage(named: "Mercedes-Benz")!),
//        GroupData(groupName: "Porsche", groupAvatar: UIImage(named: "Porsche")!),
//        GroupData(groupName: "Rolls-Roys", groupAvatar: UIImage(named: "Rolls-Roys")!),
//        GroupData(groupName: "Volvo", groupAvatar: UIImage(named: "Volvo")!)
//    ]
    
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
