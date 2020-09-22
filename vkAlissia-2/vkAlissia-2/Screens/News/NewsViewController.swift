//
//  NewsViewController.swift
//  vkAlissia
//
//  Created by Роман Колосов on 20.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    // UI
    @IBOutlet weak var tableView: UITableView!
    
    // Some properties
    private let networkManager = NetworkManager.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        networkManager.loadNewsFeed()
        
        tableView.register(UINib(nibName: "NewsCell", bundle: Bundle.main), forCellReuseIdentifier: "NewsCell")
    }
}
