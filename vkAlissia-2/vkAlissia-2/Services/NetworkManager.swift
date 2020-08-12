//
//  NetworkManager.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 12.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        //configuration.allowsCellularAccess = false
        let session =  URLSession(configuration: configuration)
        return session
    }()
    
    func getData(for method: String) {
        guard method == "groups" || method == "friends" || method == "photos" else { return }
        var urlConstructor = URLComponents()
               urlConstructor.scheme = "https"
               urlConstructor.host = "api.vk.com"
               urlConstructor.path = "/method/\(method).get"
               urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: Session.shared.token),
                   URLQueryItem(name: "extended", value: "1"),
                   URLQueryItem(name: "v", value: "5.122")
               ]
        
        guard let url = urlConstructor.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.allowsCellularAccess = false
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                    print(json)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}
