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
    //var newsData: Array<NewsItemdData>?
    var newsData = [NewsItemOfItem]()
    private let networkManager = NetworkManager.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: - Main methods
    
    private func loadData(completion: (() -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            self?.networkManager.loadNewsFeed() { [weak self] result in
                
                switch result {
                case let .success(newsItems):
                    //let newsData: [NewsItemdData] = newsItems.map {NewsItemdData(newsItem: $0)}
                    print("Hello from success ", #function)
                    DispatchQueue.main.async { [weak self] in
                        self?.newsData.removeAll()
                        //self?.newsData = newsData.map{$0}
                        self?.newsData = newsItems
                        self?.tableView.reloadData()
                        completion?()
                    }
                case let .failure(error):
                    print("Hello from failure ", #function)
                    self?.showAlert(title: "Error", message:
                        error.localizedDescription)
                }
            }
        }
    }
    
}
