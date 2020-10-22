//
//  NewsViewController.swift
//  vkAlissia
//
//  Created by Роман Колосов on 20.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit
import RealmSwift

class NewsViewController: BaseViewController {
    
    // UI
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "NewsCell", bundle: Bundle.main), forCellReuseIdentifier: "NewsCell")
        }
    }
    
    // Some properties
    var news: [ItemNewsItem]?
    private let networkManager = NetworkManager.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData() {[weak self] in self?.tableView.reloadData()}
    }
    
    // MARK: - Main methods
    
    private func loadData(completion: (() -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            self?.networkManager.loadNewsFeed() { [weak self] result in
                
                switch result {
                case let .success(newsItems):
                    DispatchQueue.main.async { [weak self] in
                        self?.news?.removeAll()
                        self?.news = newsItems.map{$0}
                        //self?.news = newsItems
                        completion?()
                    }
                case let .failure(error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
}
