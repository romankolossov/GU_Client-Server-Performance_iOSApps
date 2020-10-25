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
        return newsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else { fatalError() }
       
        let oneNews = self.newsData[indexPath.row]
        //let newsProfile = self.newsProfileData[indexPath.row]
        
        let imageStringURL = oneNews.attachments?.first?.photo?.sizes[1].url
        
        //cell.newsProviderNameLabel.text = newsProfile.firstName
        //cell.newsProviderAvatar.sd_setImage(with: URL(fileURLWithPath: userProfile.ownerPhoto))

        cell.newsTextView.text = oneNews.newsText
        cell.newsImageView.sd_setImage(with: URL(string: imageStringURL ?? ""))
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate {
    
}

