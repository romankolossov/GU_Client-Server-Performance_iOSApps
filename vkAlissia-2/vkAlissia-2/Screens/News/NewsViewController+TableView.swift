//
//  NewsViewController+TableView.swift
//  vkAlissia-3
//
//  Created by Роман Колосов on 15.09.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - UITableViewDataSource

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else { fatalError() }
       
        
//        let particularNews = news[indexPath.row]
//        let userProfile = profiles[indexPath.row]
//    
//        cell.newsProviderNameLabel.text = userProfile.userName
//        cell.newsProviderAvatar.sd_setImage(with: URL(fileURLWithPath: userProfile.ownerPhoto))
//        
//        cell.newsTextView.text = particularNews.postText
//        cell.newsImageView.sd_setImage(with: URL(fileURLWithPath: particularNews.postImage))
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate {
    
}

