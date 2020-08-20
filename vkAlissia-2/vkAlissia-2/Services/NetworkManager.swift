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
    
    let vkAPIVersion: String = "5.122"
    
    // MARK: - networkRequest
    func networkRequest(for method: String, with endPoint: String, completion: ((Result<[Any], Error>) -> Void)? = nil) {
        guard (method == "groups" || method == "friends" || method == "photos") && (endPoint == "get" || endPoint == "search") else {
            print("error: argument(s) of the method networkRequest \(method) and(or) \(endPoint) is out of range")
            return }
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/\(method).\(endPoint)"
        
        switch method {
        case "groups":
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: Session.shared.token),
                URLQueryItem(name: "user_id", value: String(Session.shared.userId)),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "v", value: vkAPIVersion)
            ]
        case "friends":
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: Session.shared.token),
                URLQueryItem(name: "user_id", value: String(Session.shared.userId)),
                URLQueryItem(name: "order", value: "random"),
                URLQueryItem(name: "offset", value: "5"),
                URLQueryItem(name: "fields", value: "city,country,domain"),
                URLQueryItem(name: "name_case", value: "nom"),
                URLQueryItem(name: "v", value: vkAPIVersion)
            ]
        case "photos":
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: Session.shared.token),
                URLQueryItem(name: "owner_id", value: "-1"),
                //URLQueryItem(name: "owner_id", value: String(Session.shared.userId)),
                URLQueryItem(name: "album_id", value: "profile"),
                URLQueryItem(name: "rev", value: "0"),
                URLQueryItem(name: "offset", value: "0"),
                URLQueryItem(name: "count", value: "3"),
                URLQueryItem(name: "v", value: vkAPIVersion)
            ]
        default:
            print("error: method \(method) is out of range")
            return
        }
        
        guard let url = urlConstructor.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.allowsCellularAccess = false
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                switch (method, endPoint) {
                case ("friends", "get"):
                    do {
                        let friends = try JSONDecoder().decode(FriendQuery.self, from: data).response.items
                        completion?(.success(friends))
                    } catch {
                        completion?(.failure(error))
                    }
                case ("groups", "get"):
                    do {
                        let groups = try JSONDecoder().decode(GroupQuery.self, from: data).response.items
                        completion?(.success(groups))
                    } catch {
                        completion?(.failure(error))
                    }
                case ("photos", "get"):
                    do {
                        let photos = try JSONDecoder().decode(PhotoQuery.self, from: data).response.items
                        completion?(.success(photos))
                    } catch {
                        completion?(.failure(error))
                    }
                default:
                    print("error: method \(method) and(or) \(endPoint) is out of range")
                    return
                }
            } else if let error = error {
                completion?(.failure(error))
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - loadFriends
    func loadFriends(completion: ((Result<[FriendItem], Error>) -> Void)? = nil) {
        networkRequest(for: "friends", with: "get") {result in
            switch result {
            case let .success(friends):
                completion?(.success(friends as! [FriendItem]))
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
    
    // MARK: - loadGroups
    func loadGroups(completion: ((Result<[GroupItem], Error>) -> Void)? = nil) {
        networkRequest(for: "groups", with: "get") {result in
            switch result {
            case let .success(groups):
                completion?(.success(groups as! [GroupItem]))
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
    
    // MARK: - loadPhotos
    func loadPhotos(completion: ((Result<[PhotoItem], Error>) -> Void)? = nil) {
        networkRequest(for: "photos", with: "get") {result in
            switch result {
            case let .success(photos):
                completion?(.success(photos as! [PhotoItem]))
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
}