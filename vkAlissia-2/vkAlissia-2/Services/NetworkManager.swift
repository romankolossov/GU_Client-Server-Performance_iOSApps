//
//  NetworkManager.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 12.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation

class NetworkManager {
    
    func loadGroups(token: String) {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
               urlConstructor.scheme = "https"
               urlConstructor.host = "api.vk.com"
               urlConstructor.path = "/method/groups.get"
               urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: token),
                   URLQueryItem(name: "extended", value: "1"),
                   URLQueryItem(name: "v", value: "5.122")
               ]
        
        guard let url = urlConstructor.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allowsCellularAccess = false
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) {
                print(json)
            }
        }
        dataTask.resume()
    }
}
