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
    //var newsProfileData: [NewsProfileData] = []
    var newsProfileData: [NewsProfileItem] = []
    
    var refreshControl: UIRefreshControl?
    
    private let networkManager = NetworkManager.shared
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        loadProfileData()
        
        //setupRefreshControl()
    }
    
    // MARK: - Main methods
    
    fileprivate func setupRefreshControl() {
        // Инициализируем и присваиваем сущность UIRefreshControl
        refreshControl = UIRefreshControl()
        // Настраиваем свойства контрола, как, например,
        // отображаемый им текст
        refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        // Цвет спиннера
        refreshControl?.tintColor = .red
        // И прикрепляем функцию, которая будет вызываться контролом
        //refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
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
                    //let newsProfileData: [NewsProfileData] = newsProfileItems.map { NewsProfileData(newsProfile: $0) }
                    DispatchQueue.main.async { [weak self] in
                        self?.newsProfileData.removeAll()
                        //self?.newsProfileData = newsProfileData
                        self?.newsProfileData = newsProfileItems
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
    
    // MARK: - Actions
    
//    @objc func refreshNews() {
//        // Начинаем обновление новостей
//        self.refreshControl?.beginRefreshing()
//        // Определяем время самой свежей новости
//        // или берем текущее время
//        let mostFreshNewsDate = self.vkNews?.items.first?.repostDate ?? Date().timeIntervalSince1970
//        // отправляем сетевой запрос загрузки новостей
//        newsService.loadPartVKNews(
//            startFrom: String(mostFreshNewsDate + 1),
//            completion: { [weak self] items, error, dateFrom in
//                guard let self = self else {
//                    return
//                }
//
//                guard let news = items else {
//                    self.refreshControl?.endRefreshing()
//                    return
//                }
//
//                // выключаем вращающийся индикатор
//                self.refreshControl?.endRefreshing()
//                // проверяем, что более свежие новости действительно есть
//                guard news.items.count > 0 else { return }
//
//                // прикрепляем их в начало отображаемого массива
//                self.vkNews?.items = news.items + (self.vkNews?.items ?? [])
//                self.vkNews?.groups = news.groups + (self.vkNews?.groups ?? [])
//                self.vkNews?.profiles = news.profiles + (self.vkNews?.profiles ?? [])
//                // формируем indexPathes свежедобавленных секций и обновляем таблицу
//                let indexPathes = news.items.enumerated().map { offset, element in
//                    IndexPath(row: offset, section: 0)
//                }
//
//                self.tableView.insertRows(at: indexPathes, with: .automatic)
//            }
//        )
//    }
    
}
