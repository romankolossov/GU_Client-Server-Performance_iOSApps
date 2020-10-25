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
    var newsData: [NewsItemdData] = []
    var newsProfileData: [NewsProfileData] = []
    
    private let networkManager = NetworkManager.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        loadProfileData()
    }
    
    // MARK: - Main methods
    
    private func loadData(completion: (() -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            self?.networkManager.loadNews() { [weak self] result in
                
                switch result {
                case let .success(newsItems):
                    let newsData: [NewsItemdData] = newsItems.map { NewsItemdData(newsItem: $0) }
                    DispatchQueue.main.async { [weak self] in
                        self?.newsData.removeAll()
                        //self?.newsData = newsData.map{$0}
                        self?.newsData = newsData
                        self?.tableView.reloadData()
                        completion?()
                    }
                case let .failure(error):
                    self?.showAlert(title: "Error", message:
                        error.localizedDescription)
                }
            }
        }
    }
    
    private func loadProfileData(completion: (() -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            self?.networkManager.loadNewsProfiles() { [weak self] result in
                
                switch result {
                case let .success(newsProfileItems):
                    let newsProfileData: [NewsProfileData] = newsProfileItems.map { NewsProfileData(newsProfile: $0) }
                    DispatchQueue.main.async { [weak self] in
                        self?.newsProfileData.removeAll()
                        self?.newsProfileData = newsProfileData
                        self?.tableView.reloadData()
                        completion?()
                    }
                case let .failure(error):
                    self?.showAlert(title: "Error", message:
                        error.localizedDescription)
                }
            }
        }
    }
}
