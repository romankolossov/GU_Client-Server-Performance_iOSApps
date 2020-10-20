//
//  NewsModel.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 20.10.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation

class VKNewsDataItem {
    
    var news: [NewsItem]
    var profiles: [OwnerItem]
    var newsGroups: [OwnerItem]
    
    init(news: [NewsItem], profiles: [OwnerItem], newsGroups: [OwnerItem]) {
        self.news = news
        self.profiles = profiles
        self.newsGroups = newsGroups
    }    
}

