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
    @IBOutlet weak var tableView: UITableView!
    
    // Some properties
    private let networkManager = NetworkManager.shared
    private let realmManager = RealmManager.shared
    var publicRealmManager: RealmManager? {
        realmManager
    }
    var news = [NewsItem]()
    var newsGroups = [OwnerItem]()
    var profiles = [OwnerItem]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        loadData()
        
        tableView.register(UINib(nibName: "NewsCell", bundle: Bundle.main), forCellReuseIdentifier: "NewsCell")
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        self.networkManager.loadNewsFeed() { [weak self] result in
            
            switch result {
            case let .success(newsDataItemArray):
                let newsDataItem = newsDataItemArray[0]
                DispatchQueue.main.async { [weak self] in
                    //                        try? self?.realmManager?.add(objects: newsDataItem.items)
                    //                        try? self?.realmManager?.add(objects: newsDataItem.groups)
                    //                        try? self?.realmManager?.add(objects: newsDataItem.profiles)
                    self?.news = newsDataItem.news
                    self?.newsGroups = newsDataItem.newsGroups
                    self?.profiles = newsDataItem.profiles
                    #if DEBUG
                    print("news count from\(#function) ", self?.news.count)
                    #endif
                    self?.tableView.reloadData()
                    completion?()
                }
            case let .failure(error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
