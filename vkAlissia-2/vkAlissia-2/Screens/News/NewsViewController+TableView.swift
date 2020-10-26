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
        newsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else { fatalError() }
       
        let news = self.newsData[indexPath.row]
        let newsGroup = self.newsGroupData.filter{ abs($0.id ?? 0) == abs(news.sourceID ?? 0) }.first
        
        let newsImageURL = news.attachments?.first?.photo?.sizes[1].url
        let newsGroupImageURL = newsGroup?.photo200
        
        cell.newsProviderNameLabel.text = newsGroup?.name
        cell.newsProviderAvatar.sd_setImage(with: URL(string: newsGroupImageURL ?? ""))
    
        cell.newsTextView.text = news.newsText
        cell.newsImageView.sd_setImage(with: URL(string: newsImageURL ?? ""))
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate {
    
}

